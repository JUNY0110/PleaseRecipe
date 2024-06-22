//
//  CDIngredient+CoreDataProperties.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/22/24.
//
//

import CoreData


extension CDIngredient {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDIngredient> {
        return NSFetchRequest<CDIngredient>(entityName: "Ingredient")
    }

    @NSManaged public var image: Data
    @NSManaged public var name: String
    @NSManaged public var useDate: Int32
    @NSManaged public var category: CDCategory?
    @NSManaged public var storage: CDStorage?
}

extension CDIngredient : Identifiable {}
