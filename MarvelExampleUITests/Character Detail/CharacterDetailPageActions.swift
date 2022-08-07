//
//  CharacterDetail.swift
//  MarvelExampleUITests
//
//  Created by Martin Lloyd
//

import XCTest

class CharacterDetailPageActions {

    private let app = XCUIApplication()

    func detailPageIsDisplayed() {
        XCTAssertTrue(app.scrollViews.isDisplayedWithWait(elementId: CharacterDetailPageObject.characterDetailPage), "page not displayed")
    }
}
