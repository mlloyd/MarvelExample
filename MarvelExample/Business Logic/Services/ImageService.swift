//
//  ImageService.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation
import UIKit

typealias ImageModel = (image: UIImage, fromCache: Bool)
typealias ImageCompletion = (Result<ImageModel, Error>) -> Void

protocol ImageServiceProtocol: AnyObject {
    func fetchImage(imageURL: URL, completion: @escaping ImageCompletion)
    func cancelImage(imageURL: URL)
}

final class ImageService: ImageServiceProtocol {

    typealias ImageCache = NSCache<NSString, UIImage>

    private let cache: ImageCache = {
        let cache = ImageCache()
        cache.countLimit = 100
        return cache
    }()

    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }

    func fetchImage(imageURL: URL, completion: @escaping ImageCompletion) {
        let key: NSString = imageURL.absoluteString as NSString

        if let image = cache.object(forKey: key) {
            completion(.success((image, fromCache: true)))
            return
        }

        dataService.fetch(url: imageURL) { [weak self] result in
            guard let self = self else { return }

            let imageResult: Result<ImageModel, Error>

            switch result {
            case let .success(data):
                if let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: key)
                    imageResult = .success((image, fromCache: false))
                } else {
                    // fixme do better.
                    imageResult = .failure(NSError())
                }

            case let .failure(error):
                imageResult = .failure(error)
            }

            DispatchQueue.main.async {
                completion(imageResult)
            }
        }
    }

    public func cancelImage(imageURL: URL) {
        dataService.cancel(url: imageURL)
    }
}
