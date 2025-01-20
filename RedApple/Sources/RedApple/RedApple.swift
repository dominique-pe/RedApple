//
//  RedApple.swift
//  RedApple
//
//  Created by Dominique Perez on 20/01/25.
//  Copyright © 2025 Dominique All rights reserved.
//

import Foundation

public enum RedAppleHTTPMethods: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

public struct RedAppleConfiguration {
    public var timeoutInterval      : TimeInterval
    public var genericErrorMessage  : String
    public var headers              : [String: String]
    
    public static var `default`: RedAppleConfiguration {
        return RedAppleConfiguration(timeoutInterval: 60.0,
                                     genericErrorMessage: "An unexpected error occurred. Please try again later.",
                                     headers: ["Accept": "application/json"])
    }
    
    public init(timeoutInterval: TimeInterval, genericErrorMessage: String, headers: [String: String] = [:]) {
        self.timeoutInterval        = timeoutInterval
        self.genericErrorMessage    = genericErrorMessage
        self.headers                = headers
    }
}

public struct RedApple {
    
    private let configuration: RedAppleConfiguration
    
    public init(configuration: RedAppleConfiguration = .default) {
        self.configuration = configuration
    }

    public func request(_ urlString: String, withMethod method: RedAppleHTTPMethods = .post,
                        withParams parameters: [String: Any] = [:], withHeaders headers: [String: String] = [:]) async throws -> Data {
        
        guard let url = URL(string: urlString) else {
            throw RedAppleError.invalidURL(urlString)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if method != .get, !parameters.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }

        urlRequest.timeoutInterval = configuration.timeoutInterval
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let error = try await self.handleErrorResponse(data)
                throw error
            }

            self.printLog(data: data, urlString: urlString)
            return data

        } catch { throw RedAppleError.requestFailed(configuration.genericErrorMessage) }
    }
}

extension RedApple {
    
    private func handleErrorResponse(_ data: Data) async throws -> RedAppleError {
        let error = try? JSONDecoder().decode(RedAppleError.self, from: data)
        return RedAppleError(code: error?.code ?? 500,
                             message: error?.message ?? configuration.genericErrorMessage,
                             detail: error?.detail ?? "No details available.")
    }
    
    private func printLog(data: Data?, urlString: String) {
        if let data = data {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                    print("\n\n***************************************************************")
                    print("SERVICE: \(urlString)")
                    print(prettyPrintedString)
                    print("***************************************************************\n\n")
                } else { print("SERVICE: \(urlString) -> JSON formatting failed") }
            } else { print("SERVICE: \(urlString) -> \(String(data: data, encoding: .utf8) ?? "No response data")") }
        } else { print("No data received") }
    }
}

public struct RedAppleError: Decodable, Error {
    var code    : Int
    var message : String
    var detail  : String
    
    static func invalidURL(_ urlString: String) -> RedAppleError {
        return RedAppleError(code: 400, message: "Invalid URL", detail: urlString)
    }
    
    static func requestFailed(_ message: String) -> RedAppleError {
        return RedAppleError(code: 500, message: message, detail: "An unexpected error occurred.")
    }
}
