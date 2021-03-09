//
//  CharactersResponse.swift
//  breakingbadgan
//
//  Created by Petar Radev on 9.03.21.
//

import Foundation

struct CharactersResponse<T: Codable>: Codable {
    let characters: [Character]
}
