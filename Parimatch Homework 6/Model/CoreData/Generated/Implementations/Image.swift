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
    func update(with imageData: ImageData) {
        self.setValue(imageData.data, forKey: "data")
        self.setValue(imageData.sha, forKey: "sha")
        self.setValue(Date(), forKey: "createdOn")
    }
}

extension Image {
    static func deleteAll() {

        let container = CoreDataStack.shared.container
        let viewContext = container.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Image.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        viewContext.perform {
            do {
                let batchDeleteResult = try viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult

                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                        into: [viewContext])
                }

                try viewContext.save()
            } catch {
                print("Error deleting all images")
            }
        }
    }
}
