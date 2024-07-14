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
    
}
