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

    private let refresher = UIRefreshControl()

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

        fetchImages()
    }
}

private extension HomeViewController {
    @objc func fetchImages() {
        collectionView?.refreshControl?.beginRefreshing()
        imageRepository.getImages { [weak self] err in
            guard err == nil else {
                print(err!)
                return
            }

            self?.collectionView?.refreshControl?.endRefreshing()
        }
    }
}

private extension HomeViewController {

    func prepareCollectionView() {
        collectionView?.register(
            UINib(nibName: ImageCollectionViewCell.reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)

        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        prepareRefresher()
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

    func prepareRefresher() {
        refresher.addTarget(self, action: #selector(fetchImages), for: .valueChanged)
        collectionView?.refreshControl = refresher
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let image = imagesDataSource?.object(at: indexPath), let data = image.data else {
            print("Can't get image data")
            return
        }

        let fullScreenImageVC = FullScreenImageViewController()

        fullScreenImageVC.imageData = data

        navigationController?.pushViewController(fullScreenImageVC, animated: true)
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
