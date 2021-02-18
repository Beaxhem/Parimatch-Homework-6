//
//  ImagesRepository.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//

import Foundation

protocol ImagesProvider {
    func getImages(completion: @escaping (Result<Image, Error>) -> Void)
}

class DefaultImagesProvider: ImagesProvider {
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = DefaultNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getImages(completion: @escaping (Result<Image, Error>) -> Void) {
        
    }
    
    
}
