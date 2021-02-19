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

    private let imageRepository: ImagesProvider = DefaultImagesProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logout))

        prepareCollectionView()
        prepareDataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        checkIfLoggedIn()

        imageRepository.getImages { err in
            guard err == nil else {
                print(err!)
                return
            }
        }
    }
}

private extension HomeViewController {

    func prepareCollectionView() {
        collectionView?.register(
            UINib(nibName: ImageCollectionViewCell.reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)

        collectionView?.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    func prepareDataSource() {
        guard let collectionView = collectionView else {
            print("Collection view is nil")
            return
        }

        imagesDataSource = ImagesDataSource(at: context, for: collectionView, displayng: ImageCollectionViewCell.self)

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

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width - 100, height: 200)
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
