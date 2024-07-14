//
//  CoreDataManager.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/17/24.
//

import CoreData
import Foundation

// TODO: 추후 Usecase와 Repository로 분리
final class CoreDataManager {
    
    // MARK: - Properties
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IngredientModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as Error? {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Init
    private init() {
        if !UserDefaults.standard.bool(forKey: "isFirstLaunch") { // 첫 접속이라면, 초기데이터를 제공한다
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            
            initialSetup()
        }
    }
    
    // MARK: - Methods
    func saveContext() {
        if context.hasChanges { // context에 변화가 있을 때만 처리.
            context.perform { [weak self] in
                do {
                    guard let self = self else { return }
                    try self.context.save()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }


    // Material을 등록해서 AddtionView에 추가하는 코드
    func registIngredient(
        _ ingredient: IngredientRegisterRequestDTO
    ) {
        let ingredientObject = CDIngredient(context: context)
        ingredientObject.image = ingredient.fetchImage()!.pngData() // jpeg로 저장 시, 투명 배경이 반영되지 않음.
        ingredientObject.useDate = Int32(ingredient.fetchUseDate())
        ingredientObject.name = ingredient.fetchName()
        ingredientObject.category = ingredient.fetchCategory()
        
        do {
            try ingredientObject.validateForInsert() // 데이터 타당성 검사
            return saveContext()
        } catch {
            context.rollback() // Context에 추가된 Material이 올바르지 않은 형태이면, 추가되기 이전 상태로 되돌림(Undo).
        }
    }
    
    
    // 저장된 재료만 가져오기 위한 메서드
    func fetchCDIngredients() -> [CDIngredient] {
        let fetchRequest = CDIngredient.fetchRequest()
        let sortByCategory = NSSortDescriptor(key: #keyPath(CDIngredient.category), ascending: true)
        let sortByName = NSSortDescriptor(key: #keyPath(CDIngredient.name), ascending: true)
        fetchRequest.sortDescriptors = [sortByCategory, sortByName]
        
        var categoryObject = [CDIngredient]()
        
        context.performAndWait {
            do {
                categoryObject = try context.fetch(fetchRequest)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        return categoryObject
    }
    
    // 검색에 필요한 데이터(재료명, 식품분류)만 가져오기 위한 메서드
    func fetchIngredientSearchItem() -> [IngredientSearchItem] {
        let ingredients = fetchCDIngredients()
        let ingredientSearchItems = ingredients.map { $0.convertToSearchItem() }
        
        return ingredientSearchItems
    }
    
    
    func deleteIngredient(_ name: String) {
        let fetchRequest = CDIngredient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let ingredients = try context.fetch(fetchRequest)
            let toDelete = ingredients[0]
            
            context.delete(toDelete)
            
            return saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func modifyMaterial() {}
}


// MARK: - CoreData Setup
extension CoreDataManager {
    private func initialSetup() {
        IngredientInfo.allCases.forEach { ingredient in
            guard let imageData = ingredient.image.jpegData(compressionQuality: 1.0) else { return }
            
            registIngredient(imageData: imageData,
                             name: ingredient.name,
                             useDate: 0,
                             category: ingredient.category.title)
        }
    }
}
