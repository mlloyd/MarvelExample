//
//  CharacterDetailViewModelTests.swift
//  MarvelExampleTests
//
//  Created by Martin Lloyd
//

import XCTest
import Combine
@testable import MarvelExample

class CharacterDetailViewModelTests: XCTestCase {

    private var viewModel: CharacterDetailViewModel!
    private var contentService: MarvelContentServiceMock!

    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        let character = MarvelContentServiceMock().characters.first!
        viewModel = CharacterDetailViewModel(character: character)
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
            case .success(let viewState):
                XCTAssertEqual(
                    viewState,
                    CharacterDetailViewModel.ViewState(
                        title: "A name",
                        description: "A description",
                        imageURL: URL(string: "something/landscape_incredible.jpg")
                    )
                )
                expectation.fulfill()
            case .error:
                XCTFail("Not configured to fail check input.")
            }

        }).store(in: &subscriptions)

        viewModel.setup()

        wait(for: [expectation], timeout: 1.0)
    }
}
