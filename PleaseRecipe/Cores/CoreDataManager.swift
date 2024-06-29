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
    
    private var context: NSManagedObjectContext {
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
        imageData: Data,
        name: String,
        useDate: Int,
        category: String
    ) {
        let categoryObject = CDCategory(context: context)
        categoryObject.title = category
        
        let ingredientObject = CDIngredient(context: context)
        ingredientObject.image = imageData
        ingredientObject.useDate = Int32(useDate)
        ingredientObject.name = name
        
        categoryObject.addToIngredients(ingredientObject)
        
        do {
            try categoryObject.validateForInsert() // 데이터 타당성 검사
            return saveContext()
        } catch {
            context.rollback() // Context에 추가된 Material이 올바르지 않은 형태이면, 추가되기 이전 상태로 되돌림(Undo).
        }
    }
    
    // 저장된 재료만 가져오기 위한 코드
    func fetchIngredients() -> [CDIngredient] {
        let fetchRequest = CDIngredient.fetchRequest()
        let sortByCategory = NSSortDescriptor(key: #keyPath(CDIngredient.category.title), ascending: true)
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
