//
//  AuthorizationViewController.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import UIKit
import AuthenticationServices

class AuthorizationViewController: UIViewController, ASWebAuthenticationPresentationContextProviding, Instantiatable {

    var authManager: AuthManager = DefaultAuthManager()

    @IBAction func githubAuthorization() {
        guard let authManager = authManager as? DefaultAuthManager else {
            return
        }

        authManager.authorizeWithGithub(contextProvider: self) { [weak self] err in
            if let err = err {
                print(err)
                return
            }

            self?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - ASWebPresentationContextProviding
extension AuthorizationViewController {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
