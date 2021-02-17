//
//  DefaultNetworkManager.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import Foundation

class DefaultNetworkManager: NetworkManager {
    func dataTask(
        urlRequest: URLRequest,
        completion: @escaping (DataTaskResult) -> Void) {

        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true

        let urlSession = URLSession(configuration: config)

        let task = urlSession.dataTask(with: urlRequest) { (data, res, err) in
            completion((data, res, err))
        }

        task.resume()
    }
}
