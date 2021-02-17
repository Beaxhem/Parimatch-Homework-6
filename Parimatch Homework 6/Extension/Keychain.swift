//
//  KeychainWrapperKey.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import KeychainAccess

extension Keychain {

    static let authorizationService = Keychain(service: "com.beaxhem.Parimatch-Homework-6")

    func get(_ key: KeychainKeys) -> String? {
        return self[key.rawValue]
    }

    func set(_ value: String, key: KeychainKeys) {
        self[key.rawValue] = value
    }
}
