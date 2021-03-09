//
//  Date+Ext.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 22.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation

extension Date {
    func getDateFormattedForServer() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
    func getDateFormattedForTab() -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(self) || calendar.isDateInYesterday(self) || calendar.isDateInTomorrow(self) {
            dateFormatter.dateStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
        } else {
            dateFormatter.dateFormat = "EE d MMM"
        }
        
        return dateFormatter.string(from: self)
    }
}
