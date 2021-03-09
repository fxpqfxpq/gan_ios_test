//
//  TimeZone+Ext.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 22.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation

extension TimeZone {
    static func timeZoneOffset() -> String {
        let seconds = current.secondsFromGMT()
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        return String(format: "%+.2d:%.2d", hours, minutes)
    }
}
