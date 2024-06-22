//
//  CDCategory+CoreDataProperties.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/22/24.
//
//

import Foundation
import CoreData
import UIKit

extension CDCategory {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCategory> {
        return NSFetchRequest<CDCategory>(entityName: "Category")
    }

    @NSManaged public var title: String
    @NSManaged public var ingredients: Array<CDIngredient>?
}


// MARK: Generated accessors for ingredients
extension CDCategory {

    @objc(insertObject:inIngredientsAtIndex:)
    @NSManaged public func insertIntoIngredients(_ value: CDIngredient, at idx: Int)

    @objc(removeObjectFromIngredientsAtIndex:)
    @NSManaged public func removeFromIngredients(at idx: Int)

    @objc(insertIngredients:atIndexes:)
    @NSManaged public func insertIntoIngredients(_ values: [CDIngredient], at indexes: NSIndexSet)

    @objc(removeIngredientsAtIndexes:)
    @NSManaged public func removeFromIngredients(at indexes: NSIndexSet)

    @objc(replaceObjectInIngredientsAtIndex:withObject:)
    @NSManaged public func replaceIngredients(at idx: Int, with value: CDIngredient)

    @objc(replaceIngredientsAtIndexes:withIngredients:)
    @NSManaged public func replaceIngredients(at indexes: NSIndexSet, with values: [CDIngredient])

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: CDIngredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: CDIngredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: Array<CDIngredient>)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: Array<CDIngredient>)

}

extension CDCategory : Identifiable {}

//extension CDCategory {
//    
//    func toDomain() -> MaterialItem {
//        return .init(
//            image: UIImage(data: ingredients?, name: <#T##String#>, useDate: <#T##Int32#>, category: <#T##String#>, storageType: <#T##String?#>
////            image: UIImage(data: ingredients.image)
////            image: UIImage(data: image),
////            name: name,
////            useDate: useDate,
////            category: category?.title ?? "",
////            storageType: "",
////            isSelected: false
//        )
//    }
//}
