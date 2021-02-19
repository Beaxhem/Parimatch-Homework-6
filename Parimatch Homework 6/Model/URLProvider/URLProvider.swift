//
//  URLProvider.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import Foundation

final class URLProvider {

    static let authorizationURL = URLComponents(string: "https://github.com/login/oauth/authorize")

    static let accessTokenURL = URLComponents(string: "https://github.com/login/oauth/access_token")

    static let repositoryContentURL = URLComponents(
        string: "https://api.github.com/repos/Parimatch-Homework-6/images/contents")

}
