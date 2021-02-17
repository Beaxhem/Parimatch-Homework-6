//
//  URLProvider.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import Foundation

class URLProvider {
    static let authorizationURL = URLComponents(string: "https://github.com/login/oauth/authorize")

    static let accessTokenURL = URLComponents(string: "https://github.com/login/oauth/access_token")
}
