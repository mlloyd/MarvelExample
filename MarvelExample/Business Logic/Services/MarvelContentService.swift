//
//  MarvelContentService.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

enum MarvelContentError: Error {
    case failedToParse, offline, unknown
}

typealias MarvelResult = Result<[Character], MarvelContentError>
typealias MarvelCompletion = (MarvelResult) -> Void

protocol MarvelContentServiceProtocol {
    func fetchCharacters(info: MarvelFetchInfo, completion: @escaping MarvelCompletion)
}

final class MarvelContentService: MarvelContentServiceProtocol {

    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }

    func fetchCharacters(info: MarvelFetchInfo, completion: @escaping MarvelCompletion) {

        dataService.fetch(url: info.url) { result in
            let contentResult: MarvelResult

            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601

                    let model = try decoder.decode(Response<Character>.self, from: response)
                    contentResult = .success(model.data.results)

                } catch {
                    contentResult = .failure(.failedToParse)
                }
            case .failure:
                // TODO.. handle futher errors in a verbose way.. with user recoverable actions.
                contentResult = .failure(.unknown)
            }

            DispatchQueue.main.async {
                completion(contentResult)
            }
        }
    }
}
