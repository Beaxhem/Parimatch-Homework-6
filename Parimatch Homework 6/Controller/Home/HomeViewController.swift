//
//  HomeViewController.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView?

    private let authManager: AuthManager = DefaultAuthManager()

    private let context: NSManagedObjectContext = CoreDataStack.shared.viewContext

    private var imagesDataSource: ImagesDataSource?

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
}

private extension HomeViewController {

    func prepareCollectionView() {
        collectionView?.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
    }

    func prepareDataSource() {
        guard let collectionView = collectionView else {
            print("Collection view is nil")
            return
        }

        imagesDataSource = ImagesDataSource(at: context, for: collectionView)

        collectionView.dataSource = imagesDataSource
        collectionView.delegate = self
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let image = imagesDataSource?.object(at: indexPath) else {
            return
        }

        print(image)

        return
    }
}

private extension HomeViewController {

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
        authManager.logout()
        checkIfLoggedIn()
    }
}
