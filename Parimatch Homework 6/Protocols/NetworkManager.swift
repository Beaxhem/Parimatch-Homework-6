//
//  NetworkManager.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import UIKit

protocol NetworkManager {

    typealias DataTaskResult = (Data?, HTTPURLResponse?, Error?)

    func dataTask(urlRequest: URLRequest, completion: @escaping (DataTaskResult) -> Void)
}
