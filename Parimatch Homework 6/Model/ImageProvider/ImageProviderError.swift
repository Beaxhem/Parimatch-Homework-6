//
//  ImageProviderError.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 21.02.2021.
//

import Foundation

enum ImageProviderError: Error {
    case badURL(url: String)
    case accessTokenUnreachable
    case networkError
    case errorDecodingImagesData
}
