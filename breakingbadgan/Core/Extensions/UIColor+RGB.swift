//
//  UIColor+RGB.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 17.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    /// Define our colors here
    
    static let colorPrimary = UIColor.rgba(r: 0x56, g: 0xAB, b: 0x2F, a: 0xFF)
    static let colorAccent = UIColor.rgba(r: 0xD6, g: 0x65, b: 0x2C, a: 0xFF)
    static let colorBorderLight = UIColor.rgba(r: 0x00, g: 0x00, b: 0x00, a: 0x1F)
    static let colorBorderButtonPressed = UIColor.rgba(r: 0xAA, g: 0xAA, b: 0xAA, a: 0x33)
    
    /// Dark text color for light background
    static let textDarkPrimary = UIColor.rgba(r: 0x00, g: 0x00, b: 0x00, a: 0xDE)       // DE for 87% opacity
    static let textDarkSecondary = UIColor.rgba(r: 0x00, g: 0x00, b: 0x00, a: 0x8A)     // 8A for 54% opacity
    static let textDarkDisabled = UIColor.rgba(r: 0x00, g: 0x00, b: 0x00, a: 0x61)      // 61 for 38% opacity
    
    /// White text color for dark background
    static let textLightPrimary = UIColor.rgba(r: 0xFF, g: 0xFF, b: 0xFF, a: 0xFF)      // 100% opacity
    static let textLightSecondary = UIColor.rgba(r: 0xFF, g: 0xFF, b: 0xFF, a: 0xB2)    // B2 for 70% opacity
    static let textLightDisabled = UIColor.rgba(r: 0xFF, g: 0xFF, b: 0xFF, a: 0x80)     // 80 for 50% opacity
    
    static let divder = UIColor.rgba(r: 0x00, g: 0x00, b: 0x00, a: 0x61)
    static let login_gradient_start = UIColor.rgba(r: 0x56, g: 0xAB, b: 0x2F, a: 0xFF)
    static let login_gradient_end = UIColor.rgba(r: 0xA8, g: 0xE0, b: 0x63, a: 0xFF)
    
    
    // MARK: - extension methods
    
    
    static func rgba(r: Float, g: Float, b: Float, a: Float) -> UIColor {
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
}
