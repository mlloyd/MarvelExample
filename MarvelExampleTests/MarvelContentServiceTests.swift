//
//  MarvelContentServiceTests.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import XCTest
@testable import MarvelExample

class MarvelContentServiceTests: XCTestCase {

    private let localDataService: DataService = LocalDataService(bundle: Bundle(for: MarvelContentServiceTests.self))
    private var marvelContentService: MarvelContentServiceProtocol!

    override func setUp() {
        super.setUp()

        self.marvelContentService = MarvelContentService(dataService: self.localDataService)
    }

    override func tearDown() {
        self.marvelContentService = nil

        super.tearDown()
    }

    func testFetchCharacters() {
        let expectation = self.expectation(description: "waiting")
        let info = MarvelCharacterFetchInfo()

        self.marvelContentService.fetchCharacters(info: info) { result in
            expectation.fulfill()

            switch result {
            case let .success(characters):
                XCTAssertEqual(characters.count, 25)

                let character = characters.first!
                XCTAssertEqual(character.name, "Mr. Negative")
                XCTAssertEqual(character.description, "")
                XCTAssertEqual(character.thumbnail.extension, "jpg")
                XCTAssertEqual(character.thumbnail.path, "http://i.annihil.us/u/prod/marvel/i/mg/8/70/4c002efc322e3")
                XCTAssertEqual(character.thumbnail.imageURL, URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/8/70/4c002efc322e3/landscape_incredible.jpg"))
                XCTAssertEqual(character.urls!.count, 3)

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 3.0, handler: nil)
    }
}
