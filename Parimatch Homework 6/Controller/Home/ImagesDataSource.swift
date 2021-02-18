//
//  ImagesDataSource.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//

import UIKit
import CoreData

class ImagesDataSource: UICollectionViewFetchedResultsController<Image> {

    private let cellClass: UICollectionViewCell.Type

    private let context: NSManagedObjectContext

    init(at context: NSManagedObjectContext,
         for collectionView: UICollectionView,
         displayng cellClass: UICollectionViewCell.Type = UICollectionViewCell.self) {

        self.cellClass = cellClass
        self.context = context

        let frc = ImagesFRC.make(at: context)
        super.init(with: collectionView, and: frc)

        do {
            try frc.performFetch()

        } catch {
            print("1")
        }
    }

    public func object(at indexPath: IndexPath) -> Image {
        frc.object(at: indexPath)
    }
}

extension ImagesDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        frc.sections?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Can't deque collection view cell")
        }

        let imageData = frc.object(at: indexPath)

        guard let data = imageData.data else {
            fatalError("Can't get image data from imageData")
        }

        let image = UIImage(data: data)

        cell.image = image

        return cell
    }

}
