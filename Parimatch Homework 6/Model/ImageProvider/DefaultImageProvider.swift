//
//  ImagesRepository.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//

import Foundation
import KeychainAccess
import CoreData

class DefaultImagesProvider: ImagesProvider {

    let networkManager: NetworkManager

    let keychain = Keychain.authorizationService

    init(networkManager: NetworkManager = DefaultNetworkManager()) {
        self.networkManager = networkManager
    }

    func getImages(completion: ((ImageProviderError?) -> Void)?) {

        guard let url = URLProvider.repositoryContentURL?.url else {
            completion?(ImageProviderError.badURL(url: "repository content"))
            return
        }

        guard let token = keychain.get(.accessToken) else {
            completion?(.accessTokenUnreachable)
            return
        }

        let urlRequest = URLRequestFactory.makeAuthorizedGetRequest(url: url, token: token)

        networkManager.dataTask(urlRequest: urlRequest) { [weak self] (data, res, error) in

            guard let self = self, let res = res else {
                return
            }

            guard res.statusCode == 200, error == nil, let data = data else {
                completion?(.networkError)
                return
            }

            guard let imagesData = try? JSONDecoder().decode([ImageData].self, from: data) else {
                completion?(.errorDecodingImagesData)
                return
            }

            self.syncImages(newImagesData: imagesData, completion: completion)
        }
    }
}

private extension DefaultImagesProvider {

    private func syncImages(newImagesData: [ImageData], completion: ((ImageProviderError?) -> Void)?) {

        let group = DispatchGroup()

        deleteNonexistent(newData: newImagesData)
        insertNew(newData: newImagesData, group: group)

        group.notify(queue: .main) {
            completion?(nil)
        }
    }

    private func insertNew(newData: [ImageData], group: DispatchGroup) {

        let context = CoreDataStack.shared.container.newBackgroundContext()

        guard let imagesData = filterExistingImages(newData: newData, context: context) else {
            return
        }

        context.performAndWait {
            for var imageData in imagesData {
                if imageData.name == ".gitignore" {
                    continue
                }

                guard let url = URL(string: imageData.downloadURL) else {
                    print("Bad download url")
                    return
                }

                group.enter()

                guard let token = keychain.get(.accessToken) else {
                    return
                }

                let urlRequest = URLRequestFactory.makeAuthorizedGetRequest(url: url, token: token)

                self.networkManager.dataTask(urlRequest: urlRequest) { data, res, error in

                    guard error == nil, let res = res, res.statusCode == 200, let data = data else {
                        return
                    }
                    guard let newImage = NSEntityDescription.insertNewObject(
                            forEntityName: "Image",
                            into: context) as? Image else {
                        return
                    }

                    imageData.data = data
                    newImage.update(with: imageData)

                    if context.hasChanges {
                        try? context.save()
                    }

                    group.leave()
                }
            }
        }
    }

    private func deleteNonexistent(newData: [ImageData]) {

        let context = CoreDataStack.shared.container.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Image.fetchRequest()

        let imagesSHA = newData.map { $0.sha }
        fetchRequest.predicate = NSPredicate(format: "NOT sha in %@", imagesSHA)

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            _ = try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Can't delete nonexistent images")
        }
    }
}

private extension DefaultImagesProvider {
    func filterExistingImages(newData: [ImageData], context: NSManagedObjectContext) -> [ImageData]? {
        let request: NSFetchRequest = Image.fetchRequest()

        let imagesURL = newData.map { $0.sha }

        request.predicate = NSPredicate(format: "sha IN %@", imagesURL)

        guard let items = try? context.fetch(request) else {
            return nil
        }

        let existingImageURLs = items.compactMap { $0.sha }
        let newImagesData = newData.filter { !existingImageURLs.contains($0.sha) }

        return newImagesData
    }
}
