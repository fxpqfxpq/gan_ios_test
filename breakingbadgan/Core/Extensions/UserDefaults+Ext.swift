//
//  UserDefaults+Ext.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 15.07.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation

enum PushTopic: String {
    case free = "free"
    case paid = "paid"
}

extension UserDefaults {
    static let keyNotifFree = "keyNotifFree"
    static let keyNotifPaid = "keyNotifPaid"
    
    // Messages will be turned on by default
    static func freeNotificationsTurnedOn() -> Bool {
        let defaults = UserDefaults.standard
        
        guard let freeNotifOn = defaults.object(forKey: keyNotifFree) as? Bool else { return false }
        
        return freeNotifOn
    }
    
    // Messages will be turned on by default
    static func paidNotificationsTurnedOn() -> Bool {
        let defaults = UserDefaults.standard
        
        guard let paidNotifOn = defaults.object(forKey: keyNotifPaid) as? Bool else { return false }
        
        return paidNotifOn
    }
    
    static func setPushNotifOn(_ on: Bool, for topic: PushTopic) {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            
            switch topic {
            case .free:
                defaults.set(on, forKey: keyNotifFree)
            case .paid:
                defaults.set(on, forKey: keyNotifPaid)
            }
        }
    }
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    static func isFreeNotifKeyPresent() -> Bool {
        return isKeyPresentInUserDefaults(key: keyNotifFree)
    }
    
    static func isPaidNotifKeyPresent() -> Bool {
        return isKeyPresentInUserDefaults(key: keyNotifPaid)
    }
}
