//
//  Helpers.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import Foundation

enum KeychainKeys: String {
    case accessToken
}

class GithubSecretsProvider {
    static let clientID = encode(url: "ce5687a6da8aaae20bd0")

    static let secret = encode(url: "9c5e24713e4c71bfb1043b120fc5ef6e9f698534")
    
    static func encode(url: String) -> String {
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return ""
        }

        return encodedURL
    }
}
