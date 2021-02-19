//
//  Image+CoreDataClass.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//
//

import Foundation
import CoreData

@objc(Image)
public class Image: NSManagedObject {

}

extension Image {
    static func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Image")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            _ = try CoreDataStack.shared.container.viewContext.execute(batchDeleteRequest)
            try CoreDataStack.shared.container.viewContext.save()
        } catch {
            print("Error deleting all images")
        }
    }
}
