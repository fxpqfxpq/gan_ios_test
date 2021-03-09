//
//  Character.swift
//  breakingbadgan
//
//  Created by Petar Radev on 9.03.21.
//

import Foundation

struct Character: Codable {
    let char_id: Int
    let name: String
    let birthday: String
    let occupation: [String]
    let img: String
    let status: String
    let nickname: String
    let appearance: [Int]
    let portrayed: String
    let category: String
    let better_call_saul_appearance: [Int]
}
