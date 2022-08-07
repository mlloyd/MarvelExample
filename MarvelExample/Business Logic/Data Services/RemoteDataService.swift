//
//  RemoteDataService.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Foundation

class RemoteDataService: DataService {

    private let session = URLSession(configuration: URLSessionConfiguration.default)

    func fetch(url: URL, completionHandler: @escaping DataServiceCompletion) {
        let task = session.dataTask(with: url) { (data, _, error) in
            guard error == nil, let data = data else {
                completionHandler(.failure(error!))
                return
            }
            completionHandler(.success(data))
        }

        task.resume()
    }

    func cancel(url: URL) {
        session.getAllTasks {
            $0.filter({ $0.originalRequest?.url == url })
              .forEach({ $0.cancel() })
        }
    }

    func cancelAll() {
        session.getAllTasks { $0.forEach({ $0.cancel() }) }
    }

    func reset() {
        cancelAll()
        URLCache.shared.removeAllCachedResponses()
    }
}
