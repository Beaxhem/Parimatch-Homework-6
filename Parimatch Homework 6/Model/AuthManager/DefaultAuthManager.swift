//
//  AuthManager.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import SwiftKeychainWrapper

class DefaultAuthManager: AuthManager {
    
    var keychain = KeychainWrapper(serviceName: "authorization")
    
    func isLoggedIn() -> Bool {
        let isLoggedIn = keychain.bool(forKey: .isLoggedIn)
        
        return isLoggedIn ?? false
    }
    
    func authorize() {
        
    }
}
