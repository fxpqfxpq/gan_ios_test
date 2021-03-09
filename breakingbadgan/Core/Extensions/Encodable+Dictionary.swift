//
//  Encodable+Dictionary.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 18.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments) as? [String: Any] else { throw NSError() }
        
        return dictionary
    }
}
