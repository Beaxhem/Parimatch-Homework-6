//
//  SceneDelegate.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import UIKit
import KeychainAccess
import LocalAuthentication

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let keychain = Keychain.authorizationService

    var blurEffectView: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return blurEffectView
    }()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {

        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        handleLocalAuthentication()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStack.shared.save()
    }
}

private extension SceneDelegate {

    func handleLocalAuthentication() {
        if keychain.get(.accessToken) != nil {
            guard let rootViewController = window?.rootViewController else {
                return
            }

            blurEffectView.frame = rootViewController.view.bounds
            rootViewController.view.addSubview(blurEffectView)

            let context = LAContext()
            var error: NSError?

            switch context.biometryType {
            case .faceID, .touchID:
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                           localizedReason: "Test",
                                           reply: policyEvaluationHandler)

                }
            case .none:
                if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                    context.evaluatePolicy(.deviceOwnerAuthentication,
                                           localizedReason: "Test",
                                           reply: policyEvaluationHandler)
                }
            @unknown default:
                blurEffectView.removeFromSuperview()
            }
        }
    }

    func policyEvaluationHandler(success: Bool, error: Error?) {
        if !success {
            self.authenticationFailureHandler()
        } else {
            DispatchQueue.main.sync {
                blurEffectView.removeFromSuperview()
            }
        }
    }

    func authenticationFailureHandler() {
        DispatchQueue.main.sync {
            window?.rootViewController = AuthorizationFailureViewController()
        }
    }
}
