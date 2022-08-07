//
//  CharacterListPageActions.swift
//  MarvelExampleUITests
//
//  Created by Martin Lloyd
//

import XCTest

class CharacterListPageActions {

    private let app = XCUIApplication()

    func characterListPageIsDisplayed() {
        XCTAssertTrue(app.cells.isDisplayedWithWait(elementId: CharacterListPageObject.characterListCell), "cell not displayed")
    }

    func clickCharacterCell() {
        app.cells.clickWithWait(elementId: CharacterListPageObject.characterListCell)
    }
}
