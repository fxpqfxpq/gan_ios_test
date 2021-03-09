//
//  KeyedContainerProtocol+EvaluatingNil.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 23.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation

public extension KeyedDecodingContainerProtocol {
    
    /**
     Decoding method that makes a distinction between keys which are not present, and keys which are explicitily set to `null`.
     - `nil` or `.none`: represents a missing key.
     - `"value"` or `.some("value")`: represents a value.
     - `.some(nil)`: represents `null`.
     */
    func decodeIfPresentEvaluatingNil<T>(_ type: T.Type, forKey key: Self.Key) throws -> T?? where T: Decodable {
        
        switch try? self.decodeNil(forKey: key) {
        case .some(true):
            return .some(nil)
        case .some(false):
            return try self.decodeIfPresent(T.self, forKey: key)
        case .none:
            return nil
        }
    }
}
