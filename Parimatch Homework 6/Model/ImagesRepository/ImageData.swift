//
//  ImageData.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//

import Foundation

struct ImageData: Codable {
    // in case the image was changed, but the name was left unchanged
    var sha: String
    var name: String
    var downloadURL: String

    enum CodingKeys: String, CodingKey {
        case sha
        case name
        case downloadURL = "download_url"
    }
}
