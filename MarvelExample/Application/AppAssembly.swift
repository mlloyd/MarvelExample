//
//  AppAssembly.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

final class AppAssembly {

    static let shared = AppAssembly()

    let remoteDataService: DataService = RemoteDataService()
    let marvelContentService: MarvelContentServiceProtocol
    let imageService: ImageServiceProtocol

    private init() {
        marvelContentService = MarvelContentService(dataService: remoteDataService)
        imageService = ImageService(dataService: remoteDataService)
    }
}
