//
//  HomeFRC.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import CoreData

class HomeFRC: NSFetchedResultsController<Image> {
    class func make(at context: NSManagedObjectContext) -> HomeFRC {

        let request: NSFetchRequest<Image> = Image.fetchRequest()

        let result = HomeFRC(fetchRequest: request,
                             managedObjectContext: context,
                             sectionNameKeyPath: nil,
                             cacheName: nil)
        return result
    }
}
