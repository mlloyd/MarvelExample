//
//  DataService.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

typealias DataServiceCompletion = (Result<Data, Error>) -> Void

protocol DataService: AnyObject {
    func fetch(url: URL, completionHandler: @escaping DataServiceCompletion)
    func cancel(url: URL)
    func cancelAll()
}
