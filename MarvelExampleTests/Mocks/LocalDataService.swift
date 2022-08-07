//
//  LocalDataService.swift
//  MarvelExampleTests
//
//  Created by Martin Lloyd
//

import Foundation
@testable import MarvelExample

final class LocalDataService: DataService {

    private let bundle: Bundle

    init(bundle: Bundle) {
        self.bundle = bundle
    }

    enum LocalDataError: Error {
        case failedToMockData
    }

    func fetch(url: URL, completionHandler: @escaping DataServiceCompletion) {
        let fileName = url.pathComponents.last!

        guard let path = bundle.path(forResource: fileName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
            completionHandler(.failure(LocalDataError.failedToMockData))
            return
        }
        print("\u{1f60e} Using Local Data Service - \(fileName) \u{1f60e}")

        DispatchQueue.main.async {
            completionHandler(.success(data))
        }
    }

    func cancel(url: URL) {
        // nop can't cancel as it will always succeed
    }

    func cancelAll() {

    }

    func reset() {

    }
}
