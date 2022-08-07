//
//  Link.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

struct Link: Codable, Hashable {

    enum LinkType: String, Codable {
        case detail, wiki, comiclink
    }

    let type: LinkType
    let url: URL
}
