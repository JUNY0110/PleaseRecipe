//
//  CDIngredient+CoreDataProperties.swift
//  PleaseRecipe
//
//  Created by 지준용 on 7/11/24.
//
//

import Foundation
import CoreData


extension CDIngredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDIngredient> {
        return NSFetchRequest<CDIngredient>(entityName: "Ingredient")
    }

    @NSManaged public var category: String
    @NSManaged public var image: Data?
    @NSManaged public var name: String
    @NSManaged public var useDate: Int32
    @NSManaged public var storages: Array<CDStorage>?
}

// MARK: Generated accessors for storages
extension CDIngredient {

    @objc(insertObject:inStoragesAtIndex:)
    @NSManaged public func insertIntoStorages(_ value: CDStorage, at idx: Int)

    @objc(removeObjectFromStoragesAtIndex:)
    @NSManaged public func removeFromStorages(at idx: Int)

    @objc(insertStorages:atIndexes:)
    @NSManaged public func insertIntoStorages(_ values: [CDStorage], at indexes: NSIndexSet)

    @objc(removeStoragesAtIndexes:)
    @NSManaged public func removeFromStorages(at indexes: NSIndexSet)

    @objc(replaceObjectInStoragesAtIndex:withObject:)
    @NSManaged public func replaceStorages(at idx: Int, with value: CDStorage)

    @objc(replaceStoragesAtIndexes:withStorages:)
    @NSManaged public func replaceStorages(at indexes: NSIndexSet, with values: [CDStorage])

    @objc(addStoragesObject:)
    @NSManaged public func addToStorages(_ value: CDStorage)

    @objc(removeStoragesObject:)
    @NSManaged public func removeFromStorages(_ value: CDStorage)

    @objc(addStorages:)
    @NSManaged public func addToStorages(_ values: Array<CDStorage>)

    @objc(removeStorages:)
    @NSManaged public func removeFromStorages(_ values: Array<CDStorage>)
}

extension CDIngredient : Identifiable {}
