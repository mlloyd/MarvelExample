//
//  AsyncResult.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

enum AsyncResult<T> {
    case loading
    case success(T)
    case error(Error)
}
