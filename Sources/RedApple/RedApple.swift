//
//  RedApple.swift
//  RedApple
//
//  Created by Dominique Pérez on 21/01/25.
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

public struct RedApple {
    
    private let configuration: RedAppleConfiguration
    
    public init(configuration: RedAppleConfiguration = .default) {
        self.configuration = configuration
    }
    
    public func request(_ urlString: String,
                         method: RedAppleHTTPMethods = .post,
                         parameters: [String: Any] = [:],
                         headers: [String: String] = [:]) async throws -> Data {
        
        guard let url = URL(string: urlString), url.scheme?.hasPrefix("http") == true else {
            throw NSError(domain: "pe.dominique",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "SERVICE: \(urlString) not found"])
        }

        var urlRequest = URLRequest(url: url)
        configureRequest(&urlRequest, method: method, parameters: parameters, headers: headers)
        
        do {
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self.printLog(data: data, urlString: urlString)
                let code = response as? HTTPURLResponse
                throw RedAppleError(code: code?.statusCode ?? 0, data: data)
            }
            
            return data
        }
    }
}

extension RedApple {
    
    private func configureRequest(_ request: inout URLRequest,
                                  method: RedAppleHTTPMethods,
                                  parameters: [String: Any],
                                  headers: [String: String]) {
      
        request.httpMethod      = method.rawValue
        request.timeoutInterval = configuration.timeoutInterval
        self.configureHeaders(&request, with: headers)
        
        if method != .get, !parameters.isEmpty {
            do { try setRequestBody(&request, with: parameters) } catch { request.httpBody = Data() }
        }
    }

    private func configureHeaders(_ request: inout URLRequest, with headers: [String: String]) {
        var combinedHeaders = configuration.headers
        headers.forEach { combinedHeaders[$0.key] = $0.value }
        
        combinedHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

    private func setRequestBody(_ request: inout URLRequest, with parameters: [String: Any]) throws {
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = bodyData
        } catch {
            let urlString = request.url?.absoluteString
            throw NSError(domain: "pe.dominique",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "SERVICE: \(urlString ?? "") -> Failed to serialize parameters."])
        }
    }
    
    private func printLog(data: Data?, urlString: String) {
        
        guard RedAppleConfiguration.showConsoleLogs else { return }
        
        if let data = data {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                    print("\n***************************************************************")
                    print("SERVICE: \(urlString)")
                    print(prettyPrintedString)
                    print("***************************************************************\n")
                } else {
                    print("SERVICE: \(urlString) -> JSON formatting failed")
                }
            } else {
                print("SERVICE: \(urlString) -> \(String(data: data, encoding: .utf8) ?? "No response data")")
            }
        } else {
            print("No data received from service: \(urlString)")
        }
    }
}
