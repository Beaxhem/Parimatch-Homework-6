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

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logout))
    }

    override func viewDidAppear(_ animated: Bool) {
        checkIfLoggedIn()
    }

    private func checkIfLoggedIn() {
        if !authManager.isLoggedIn() {
            guard let authViewController = AuthorizationViewController.instantiate() else {
                return
            }
            authViewController.authManager = authManager
            authViewController.modalPresentationStyle = .fullScreen

            navigationController?.present(authViewController, animated: true, completion: nil)
        }
    }

    @objc private func logout() {
        print("Logout")
        authManager.logout()
        checkIfLoggedIn()
    }

}