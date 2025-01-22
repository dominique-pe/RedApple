//
//  RedAppleError.swift
//  RedApple
//
//  Created by Dominique Pérez on 21/01/25.
//  Copyright © 2025 Dominique All rights reserved.
//

import Foundation

public struct RedAppleError: Error, Encodable {
    
    public let code : Int
    public let data : Data
    
    public func toData() -> Data {
        do { return try JSONEncoder().encode(self) } catch { return Data() }
    }
}
