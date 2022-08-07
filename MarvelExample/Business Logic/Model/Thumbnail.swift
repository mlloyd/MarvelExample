//
//  Thumbnail.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

// https://developer.marvel.com/documentation/images
// We use landscape_incredible variant as best sizing for our app.

struct Thumbnail: Codable, Hashable {

    enum Variants: String {
        // More available check docs above (if required)
        case landscapeIncredible = "landscape_incredible"
    }

    let path: String
    let `extension`: String
}

extension Thumbnail {

    var imageURL: URL? {
        // The data includes http.. replacing with https.. as it's possible.
        let path = path.replacingOccurrences(of: "http", with: "https")

        guard var url = URL(string: path) else {
            return nil
        }

        url.appendPathComponent(Variants.landscapeIncredible.rawValue + "." + self.extension)
        return url
    }
}
