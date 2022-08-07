//
//  Character.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

struct Character: Codable, Hashable, Identifiable {

    let id = UUID()
    let name: String
    let description: String?
    let thumbnail: Thumbnail
    let urls: [Link]?

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case thumbnail
        case urls
    }
}
