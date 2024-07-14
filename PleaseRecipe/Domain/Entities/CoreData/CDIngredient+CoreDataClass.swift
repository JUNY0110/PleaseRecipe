//
//  CDIngredient+CoreDataClass.swift
//  PleaseRecipe
//
//  Created by 지준용 on 7/11/24.
//
//

import CoreData
import Foundation

@objc(CDIngredient)
public class CDIngredient: NSManagedObject {

}
extension CDIngredient {
    func convertToSearchItem() -> IngredientSearchItem {
        return .init(name: name, category: category)
    }
    
    func convertToStorageItem(_ storage: String) -> IngredientStorageItem? {
        guard storages != nil && storages?.count != 0 else { return nil }
        guard let storage = storages?.first(where: {$0.title == storage}) else { return nil }
        
        return .init(image: image,
                     storageType: storage.title,
                     name: name,
                     registDate: storage.registDate,
                     useDate: Int(useDate),
                     category: category)
    }
}
