//
//  ImagesRepository.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//

import Foundation
import KeychainAccess
import CoreData

protocol ImagesProvider {
    func getImages(completion: ((Error?) -> Void)?)
}

class DefaultImagesProvider: ImagesProvider {

    let networkManager: NetworkManager

    let keychain = Keychain.authorizationService

    init(networkManager: NetworkManager = DefaultNetworkManager()) {
        self.networkManager = networkManager
    }

    func getImages(completion: ((Error?) -> Void)?) {
        print("start")
        guard let url = URLProvider.repositoryContentURL?.url else {
            print("Can't get url")
            return
        }

        guard let token = keychain.get(.accessToken) else {
            print("Can't get access token")
            return
        }

        let urlRequest = URLRequestFactory.makeAuthorizedGetRequest(url: url, token: token)

        networkManager.dataTask(urlRequest: urlRequest) { [weak self] (data, _, error) in
            guard let self = self, error == nil, let data = data else {
                print("Network error")
                return
            }

            guard let imagesData = try? JSONDecoder().decode([ImageData].self, from: data) else {
                print("Can't decode images data")
                return
            }

            self.syncImages(newImagesData: imagesData)
        }
    }

    private func syncImages(newImagesData: [ImageData]) {
//            self?.deleteNonexistent(context: context, fetchRequest: oldImages, newData: newImagesData)

        self.insertNew(newData: newImagesData)
//            
//            if context.hasChanges {
//                print("Context has changes")
//                try? context.save()
//            }
    }

    private func insertNew(
        newData: [ImageData]) {

        let request: NSFetchRequest = Image.fetchRequest()
        let context = CoreDataStack.shared.container.newBackgroundContext()

        let imagesURL = newData.map { $0.downloadURL }
//        fetchRequest.predicate = NSPredicate(format: "url IN %@", argumentArray: imagesURL)

        guard let items = try? context.fetch(request) else {
            return
        }

        let existingImageURLs = items.compactMap { $0.url }

        let newImagesData = newData.filter { !existingImageURLs.contains($0.url) }

        let group = DispatchGroup()

        context.performAndWait {
            for imageData in newImagesData {

                guard let url = URL(string: imageData.downloadURL) else {
                    print("Bad download url")
                    return
                }

                group.enter()
                self.networkManager.fetchImage(url: url) { res in
                    guard let newImage = NSEntityDescription.insertNewObject(
                            forEntityName: "Image",
                            into: context) as? Image else {
                        return
                    }

                    switch res {
                    case .failure(let error):
                        print(error)
                        context.delete(newImage)
                        return
                    case .success(let data):
                        newImage.setValue(data, forKey: "data")
                        newImage.setValue(imageData.sha, forKey: "sha")
                        newImage.setValue(imageData.downloadURL, forKey: "url")
                        newImage.setValue(Date(), forKey: "createdOn")
                    }

                    if context.hasChanges {
                        try? context.save()
                    }

                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            context.reset()
        }
    }

    private func deleteNonexistent(
        context: NSManagedObjectContext,
        fetchRequest: NSFetchRequest<NSFetchRequestResult>,
        newData: [ImageData]) {

        let imagesURL = newData.map { $0.downloadURL }

        fetchRequest.predicate = NSPredicate(format: "NOT(%@ in url)", argumentArray: imagesURL)

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        do {
            let batchDeleteResult = try context.execute(batchDeleteRequest)
        } catch {
            print("Can't delete nonexistent images")
        }
    }
}
