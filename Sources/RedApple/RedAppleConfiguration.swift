//
//  RedAppleConfiguration.swift
//  RedApple
//
//  Created by Dominique Pérez on 21/01/25.
//  Copyright © 2025 Dominique All rights reserved.
//

import Foundation

public struct RedAppleConfiguration {
    
    public var timeoutInterval  : TimeInterval
    public var headers          : [String: String]
    
    public static var showConsoleLogs: Bool = true
    
    public static var `default`: RedAppleConfiguration {
        return RedAppleConfiguration(
            timeoutInterval: 60.0,
            headers: ["Content-Type": "application/json; charset=utf-8"]
        )
    }
    
    public init(timeoutInterval: TimeInterval = 60.0,
                headers: [String: String] = ["Content-Type": "application/json; charset=utf-8"]) {
        self.timeoutInterval    = timeoutInterval
        self.headers            = headers
    }
}
