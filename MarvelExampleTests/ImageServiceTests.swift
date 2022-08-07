//
//  ImageServiceTests.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import XCTest
@testable import MarvelExample

class ImageServiceTests: XCTestCase {

    private let remoteDataService = RemoteDataServiceMock()
    private var imageService: ImageService!

    override func setUp() {
        super.setUp()

        self.imageService = ImageService(dataService: self.remoteDataService)
        self.remoteDataService.fail = false
    }

    override func tearDown() {
        self.imageService = nil

        super.tearDown()
    }

    // Note.. these tests are hitting the network..
    // if running on CI.. it would be wise to swap out the remoteDataService for a mock image implementation.

    func testImageFetchSuccess() {
        let expectation = self.expectation(description: "waiting")

        let imageURL = URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/8/70/4c002efc322e3/landscape_incredible.jpg")!
        self.imageService.fetchImage(imageURL: imageURL) { result in

            switch result {
            case let .success(image):
                XCTAssertNotNil(image)
                expectation.fulfill()
            case .failure:
                XCTFail("Failed to d/l image at: \(imageURL)")
            }
        }

        waitForExpectations(timeout: 3.0, handler: nil)
    }

    func testImageFetchFailed() {
        let expectation = self.expectation(description: "waiting")
        self.remoteDataService.fail = true

        let imageURL = URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/8/70/4c002efc322e3/landscape_incredible_INVALID_URL!!!.jpg")!
        self.imageService.fetchImage(imageURL: imageURL) { result in
            switch result {
            case .failure:
                expectation.fulfill()
            default:
                break
            }
        }

        waitForExpectations(timeout: 3.0, handler: nil)
    }

    func testImageFetchSuccessAndCacheLookup() {
        let imageURL = URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/8/70/4c002efc322e3/landscape_incredible.jpg")!

        let expectationAsyncImage = self.expectation(description: "waitingForImage")

        self.imageService.fetchImage(imageURL: imageURL) { result in
            expectationAsyncImage.fulfill()

            switch result {
            case let .success(model):
                XCTAssertFalse(model.fromCache)

            default: XCTFail("Image request failed")
            }
        }

        waitForExpectations(timeout: 3.0, handler: nil)

        let expectationFromCache = self.expectation(description: "waitingForImageFromCache")

        self.imageService.fetchImage(imageURL: imageURL) { result in
            expectationFromCache.fulfill()

            switch result {
            case let .success(model):
                XCTAssertTrue(model.fromCache)

            default: XCTFail("Image request failed")
            }
        }

        waitForExpectations(timeout: 3.0, handler: nil)
    }
}

private class RemoteDataServiceMock: DataService {

    var fail: Bool = false

    func fetch(url: URL, completionHandler: @escaping DataServiceCompletion) {
        if self.fail {
            let error = NSError(domain: "", code: -100, userInfo: nil)
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(UIImage.from(color: .red).pngData()!))
        }
    }

    func cancel(url: URL) {

    }

    func cancelAll() {

    }
}

private extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
