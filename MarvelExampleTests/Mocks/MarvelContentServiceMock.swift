//
//  MarvelContentServiceMock.swift
//  MarvelExampleTests
//
//  Created by Martin Lloyd
//

import Foundation
@testable import MarvelExample

class MarvelContentServiceMock: MarvelContentServiceProtocol {

    let characters = [
        Character(
            name: "A name",
            description: "A description",
            thumbnail: Thumbnail(path: "something", extension: "jpg"),
            urls: []
        )
    ]

    var useError = false

    func fetchCharacters(info: MarvelFetchInfo, completion: @escaping MarvelCompletion) {
        if useError {
            completion(.failure(MarvelContentError.unknown))
        } else {
            completion(.success(characters))
        }
    }
}
