//
//  StorageCoreDataManager.swift
//  PleaseRecipe
//
//  Created by 지준용 on 7/11/24.
//

import Foundation


// MARK: - Storage
extension CoreDataManager {
    // 구매(소유)한 재료를 저장하기 위한 메서드
    func storeIngredient(name: String, storage: String) {
        // 해당 재료명을 가진 데이터
        let fetchRequest = CDIngredient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)

        let storageObject = CDStorage(context: context)
        storageObject.title = storage
        storageObject.registDate = Date()
        
        do {
            // 해당 재료명에 저장방식을 추가함.
            let ingredients = try context.fetch(fetchRequest)
            ingredients[0].addToStorages(storageObject)
            try storageObject.validateForInsert()

            return saveContext()
        } catch {
            print(error)
        }
    }
    
    private func fetchCDStorageIngredients(_ storage: String) -> [CDIngredient] {
        let fetchRequest = CDIngredient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY storages.title = %@", storage)
        
        let sortByUseDate = NSSortDescriptor(key: #keyPath(CDIngredient.useDate), ascending: true)
        fetchRequest.sortDescriptors = [sortByUseDate]
        
        var ingredientObject = [CDIngredient]()
        
        do {
            let ingredients = try context.fetch(fetchRequest)
            ingredientObject = ingredients
        } catch {
            print(error.localizedDescription)
        }
        
        return ingredientObject
    }
    
    func fetchStoredIngredients(_ storage: String) -> [IngredientStorageItem] {
        let ingredients = fetchCDStorageIngredients(storage)
        
        return ingredients.map { $0.convertToStorageItem(storage)! }
    }
}
