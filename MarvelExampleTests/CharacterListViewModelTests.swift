//
//  CharacterListViewModelTests.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import XCTest
import Combine
@testable import MarvelExample

class CharacterListViewModelTests: XCTestCase {

    private var viewModel: CharacterListViewModel!
    private var contentService: MarvelContentServiceMock!

    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        contentService = MarvelContentServiceMock()
        viewModel = CharacterListViewModel(contentService: contentService, flow: self)
    }

    override func tearDown() {
        viewModel = nil
        contentService = nil
        subscriptions.removeAll()
        super.tearDown()
    }

    func testSetupWithSuccess() {
        let expectation = XCTestExpectation(description: "setup")
        viewModel.$viewState.sink(receiveValue: { viewState in

            switch viewState {
            case .loading:
                break
            case .success(let items):
                XCTAssertEqual(items, [
                    CharacterListViewModel.ListItem(
                        name: "A name",
                        imageURL: URL(string: "something/landscape_incredible.jpg"))
                    ]
                )
                expectation.fulfill()
            case .error:
                XCTFail("Not configured to fail check input.")
            }

        }).store(in: &subscriptions)

        viewModel.setup()

        wait(for: [expectation], timeout: 1.0)
    }

    func testSetupWithError() {
        let expectation = XCTestExpectation(description: "setup")
        viewModel.$viewState.sink(receiveValue: { viewState in

            switch viewState {
            case .loading:
                break
            case .success:
                XCTFail("No configured for success.")
            case .error(let error):
                XCTAssertEqual(error as? MarvelContentError, MarvelContentError.unknown)
                expectation.fulfill()
            }

        }).store(in: &subscriptions)

        contentService.useError = true
        viewModel.setup()

        wait(for: [expectation], timeout: 1.0)
    }
}

extension CharacterListViewModelTests: CharacterListFlow {

    func presentCharacter(character: Character) {

    }
}
