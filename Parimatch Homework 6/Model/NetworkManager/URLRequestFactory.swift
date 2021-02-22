//
//  URLRequestFactory.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//

import Foundation

final class URLRequestFactory {
    static func makePostRequest(url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        return urlRequest
    }

    static func makeGetRequest(url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)

        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        return urlRequest
    }

    static func makeAuthorizedGetRequest(url: URL, token: String) -> URLRequest {
        var getRequest = makeGetRequest(url: url)

        getRequest.setValue("token " + token, forHTTPHeaderField: "Authorization")

        return getRequest
    }

    static func makeAuthorizedPostRequest(url: URL, token: String) -> URLRequest {
        var postRequest = makePostRequest(url: url)

        postRequest.setValue("token " + token, forHTTPHeaderField: "Authorization")

        return postRequest
    }
}
