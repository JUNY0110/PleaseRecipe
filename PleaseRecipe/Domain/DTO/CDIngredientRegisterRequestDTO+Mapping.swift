//
//  CDIngredientRegisterRequestDTO+Mapping.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/30/24.
//


import UIKit

struct IngredientRegisterRequestDTO {
    private var image: UIImage?
    private var name: String
    private var useDate: Int32
    private var category: String
    
    // Init
    init(image: UIImage?, name: String, useDate: Int32, category: String) {
        self.image = image
        self.name = name
        self.useDate = useDate
        self.category = category
    }
    
    // Update
    mutating func changeImage(_ image: UIImage?) {
        self.image = image
    }
    
    mutating func changeName(_ name: String) {
        self.name = name
    }
    
    mutating func changeUseDate(_ useDate: Int) {
        self.useDate = Int32(useDate)
    }
    
    mutating func changeCategory(_ category: String) {
        self.category = category
    }
    
    // Fetch
    func fetchImage() -> UIImage? {
        return self.image
    }
    
    func fetchName() -> String {
        return self.name
    }
    
    func fetchUseDate() -> Int {
        return Int(self.useDate)
    }
    
    func fetchCategory() -> String {
        return self.category
    }
}
