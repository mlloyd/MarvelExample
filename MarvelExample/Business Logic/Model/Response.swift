//
//  Response.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

// Although optional in the API. A conscious descision to mark non-optional
// This allows Codable to throw the correct error upon parsing the response.

struct Response<ResultType: Codable>: Codable {
    let code: Int
    let status: String
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let etag: String
    let data: Data<ResultType>

    struct Data<ResultType: Codable>: Codable {
        let offset: Int
        let limit: Int
        let total: Int
        let count: Int
        let results: [ResultType]
    }
}
