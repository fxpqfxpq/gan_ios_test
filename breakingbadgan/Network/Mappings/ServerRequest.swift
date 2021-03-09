//
//  ServerRequest.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 18.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation

struct ServerRequest<T: Codable>: Codable {
    let data: T?
}
