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

            self.syncImages(newImagesData: imagesData, completion: completion)
        }
    }

    private func syncImages(newImagesData: [ImageData], completion: ((Error?) -> Void)?) {

        let group = DispatchGroup()

        deleteNonexistent(newData: newImagesData)
        insertNew(newData: newImagesData, group: group)

        group.notify(queue: .main) {
            completion?(nil)
        }
    }

    private func insertNew(
        newData: [ImageData],
        group: DispatchGroup) {

        let request: NSFetchRequest = Image.fetchRequest()
        let context = CoreDataStack.shared.container.newBackgroundContext()

        let imagesURL = newData.map { $0.sha }

        request.predicate = NSPredicate(format: "sha IN %@", imagesURL)

        guard let items = try? context.fetch(request) else {
            return
        }
        print(items.count)
        let existingImageURLs = items.compactMap { $0.sha }
        print("existing shas", existingImageURLs)
        let newImagesData = newData.filter { !existingImageURLs.contains($0.sha) }
        print("newImages count", newImagesData.count)
        context.performAndWait {
            for imageData in newImagesData {
                if imageData.name == ".gitignore" {
                    continue
                }

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
                        newImage.setValue(Date(), forKey: "createdOn")
                    }

                    if context.hasChanges {
                        try? context.save()
                    }

                    group.leave()
                }
            }
        }
    }

    private func deleteNonexistent(
        newData: [ImageData]) {

        let context = CoreDataStack.shared.container.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Image.fetchRequest()

        let imagesSHA = newData.map { $0.sha }
        print("fetched sha", imagesSHA)
        fetchRequest.predicate = NSPredicate(format: "NOT sha in %@", imagesSHA)

        guard let items = try? context.fetch(fetchRequest) as? [Image] else {
            return
        }

        print("items to delete", items)

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            _ = try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Can't delete nonexistent images")
        }
    }
}
