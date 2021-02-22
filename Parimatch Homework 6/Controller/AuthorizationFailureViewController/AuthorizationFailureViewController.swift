//
//  AuthorizationFailureViewController.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 22.02.2021.
//

import UIKit
import LocalAuthentication

class AuthorizationFailureViewController: UIViewController, Instantiatable {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authorize() {
        let context = LAContext()
        var error: NSError?

        switch context.biometryType {
        case .faceID, .touchID:
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: "Test") { [weak self] (success, _) in
                    if success {
                        DispatchQueue.main.sync {
                            self?.moveToHomeViewController()
                        }
                    }
                }
            }
        case .none:
            moveToHomeViewController()
        @unknown default:
            fatalError()
        }
    }
}

private extension AuthorizationFailureViewController {
    func moveToHomeViewController() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
          fatalError("Can't get scene delegate")
        }

        sceneDelegate.window?.rootViewController = NavigationViewController.instantiate()
    }
}
