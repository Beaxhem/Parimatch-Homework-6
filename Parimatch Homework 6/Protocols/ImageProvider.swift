//
//  ImageProvider.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 21.02.2021.
//

import Foundation

protocol ImagesProvider {
    func getImages(completion: ((ImageProviderError?) -> Void)?)
}
