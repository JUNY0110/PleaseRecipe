//
//  CDStorage+CoreDataProperties.swift
//  PleaseRecipe
//
//  Created by 지준용 on 7/11/24.
//
//

import Foundation
import CoreData


extension CDStorage {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDStorage> {
        return NSFetchRequest<CDStorage>(entityName: "Storage")
    }

    @NSManaged public var registDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var ingredient: CDIngredient?
}

extension CDStorage : Identifiable {}
