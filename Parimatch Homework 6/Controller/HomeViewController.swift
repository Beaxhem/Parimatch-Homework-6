//
//  HomeViewController.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import UIKit

class HomeViewController: UIViewController {

    let authManager: AuthManager = DefaultAuthManager()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        if !authManager.isLoggedIn() {
            guard let authViewController = AuthorizationViewController.instantiate() else {
                return
            }
            authViewController.authManager = authManager
            authViewController.modalPresentationStyle = .fullScreen

            navigationController?.present(authViewController, animated: true, completion: nil)
        }
    }
}
