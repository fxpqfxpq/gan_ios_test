//
//  Consts.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 16.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation
import UIKit

struct Consts {
    static let baseUrl = "https://breakingbadapi.com/api/"
    
    typealias VoidClosure = () -> Void
    
    enum FileExt: CustomStringConvertible {
        case TXT
        case MP3
        case AUDIOBOOK
        
        var description: String {
          switch self {
          case .TXT: return "txt"
          case .MP3: return "mp3"
          case .AUDIOBOOK: return "audiobook"
          }
        }
    }
}
