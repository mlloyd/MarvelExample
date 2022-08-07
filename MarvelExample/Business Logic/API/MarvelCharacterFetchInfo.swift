//
//  MarvelCharactorFetchInfo.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

/// https://developer.marvel.com/docs#!/public/getCreatorCollection_get_0

struct MarvelCharacterFetchInfo: MarvelFetchInfo {

    struct URLParams {
        static let timestamp = "ts"
        static let apikey = "apikey"
        static let hash = "hash"
        static let limit = "limit"
        static let orderBy = "orderBy"
    }

    private let limit: Int
    private let ascending: Bool // false = descending
    private let ordered: Ordered

    enum Ordered {
        case name, modified
    }

    var url: URL {
        var url = MarvelAPI.baseURL
        url.appendPathComponent("characters")

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: URLParams.timestamp, value: "1"))
        queryItems.append(URLQueryItem(name: URLParams.apikey, value: MarvelAPI.apikey))
        queryItems.append(URLQueryItem(name: URLParams.hash, value: MarvelAPI.hash))
        queryItems.append(URLQueryItem(name: URLParams.limit, value: String(limit)))

        switch (ascending, ordered) {
        case (true, .name):
            queryItems.append(URLQueryItem(name: URLParams.orderBy, value: "name"))
        case (true, .modified):
            queryItems.append(URLQueryItem(name: URLParams.orderBy, value: "modified"))
        case (false, .name):
            queryItems.append(URLQueryItem(name: URLParams.orderBy, value: "-name"))
        case (false, .modified):
            queryItems.append(URLQueryItem(name: URLParams.orderBy, value: "-modified"))
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        return components.url!
    }

    // Provided the default.. for the sake of the initial prototype. Expect more flexibility over time.
    init(limit: Int = 25, ascending: Bool = false, ordered: Ordered = .modified) {
        self.limit = limit
        self.ascending = ascending
        self.ordered = ordered
    }
}
