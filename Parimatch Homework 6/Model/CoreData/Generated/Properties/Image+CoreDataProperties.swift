//
//  Image+CoreDataProperties.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var data: Data?
    @NSManaged public var url: String?

}

extension Image : Identifiable {

}
