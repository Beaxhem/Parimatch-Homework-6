//
//  ImagesFRC.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import CoreData

class ImagesFRC: NSFetchedResultsController<Image> {
    class func make(at context: NSManagedObjectContext) -> ImagesFRC {

        let request: NSFetchRequest<Image> = Image.fetchRequest()

        let result = ImagesFRC(fetchRequest: request,
                             managedObjectContext: context,
                             sectionNameKeyPath: nil,
                             cacheName: nil)
        return result
    }
}
