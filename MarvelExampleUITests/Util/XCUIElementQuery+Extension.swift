//
//  XCUIElementQuery+Extension.swift
//  MarvelExampleUITests
//
//  Created by Martin Lloyd
//

import XCTest

private let defaultWait = 20.0

extension XCUIElementQuery {

    func isDisplayedWithWait(elementId: String, timeout: TimeInterval = defaultWait) -> Bool {
        let element = self[elementId]
        let isDisplayed = element.waitForExistence(timeout: timeout)
        return isDisplayed
    }

    @discardableResult
    func clickWithWait(elementId: String) -> XCUIElement {
        let element = self[elementId]
        XCTAssertTrue(element.waitForExistence(timeout: defaultWait), "Element `\(elementId)` not found after wait")
        element.firstMatch.tap()
        return element
    }
}
