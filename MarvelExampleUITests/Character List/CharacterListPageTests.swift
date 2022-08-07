//
//  CharacterListPageTests.swift
//  MarvelExampleUITests
//
//  Created by Martin Lloyd
//

import XCTest

class CharacterListPageTests: XCTestCase {

    private let app = XCUIApplication()

    private let characterListPageActions = CharacterListPageActions()

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()

        app.terminate()
    }

    func testCharacterListPageIsDisplayedAndLoads() {
        app.launch()

        characterListPageActions.characterListPageIsDisplayed()
    }
}
