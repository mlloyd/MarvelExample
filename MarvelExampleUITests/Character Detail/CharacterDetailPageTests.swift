//
//  CharacterDetailPageTests.swift
//  MarvelExampleUITests
//
//  Created by Martin Lloyd
//

import XCTest

class CharacterDetailPageTests: XCTestCase {

    private let app = XCUIApplication()

    private let characterListPageActions = CharacterListPageActions()
    private let characterDetailPageActions = CharacterDetailPageActions()

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()

        app.terminate()
    }

    func testCharacterDetailPageIsDisplayedAndLoads() {
        app.launch()

        characterListPageActions.characterListPageIsDisplayed()
        characterListPageActions.clickCharacterCell()
        characterDetailPageActions.detailPageIsDisplayed()
    }
}
