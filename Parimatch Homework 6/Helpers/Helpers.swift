//
//  Helpers.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import UIKit

enum KeychainKeys: String {
    case accessToken
}

class GithubSecretsProvider {
    static let clientID = "ce5687a6da8aaae20bd0"

    static let secret = "9c5e24713e4c71bfb1043b120fc5ef6e9f698534"
}

class ImageCellSize {
    static let insetSpacing: CGFloat = 10

    static let cellHeight: CGFloat = 250

    static func cellWidth(parentWidth: CGFloat) -> CGFloat {
        return parentWidth - 2 * insetSpacing
    }
}
