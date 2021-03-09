//
//  KeyedEncodingContainerProtocol+AnyCodable.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 23.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation

public extension KeyedEncodingContainerProtocol {
    mutating func encodeIfPresent(_ value: AnyCodable?, forKey key: Self.Key) throws {
        
        guard let someValue = value, someValue.value != nil else {
            return
        }
        
        try self.encode(someValue, forKey: key)
    }
}
