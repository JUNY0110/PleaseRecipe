//
//  IngredientItem.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/20/24.
//

import UIKit


struct IngredientItem: Hashable {
    var image: UIImage?
    var name: String
    var useDate: Int32
    var category: String
    var isSelected: Bool = false
    
    mutating func configureImage(_ image: UIImage?) {
        self.image = image
    }
    
    func fetchImage() -> UIImage? {
        return self.image
    }
    
    mutating func configureItem(
        name: String,
        useDate: Int,
        category: String
    ) {
        self.name = name
        self.useDate = Int32(useDate)
        self.category = category
    }
    
    mutating func isSelectedToggle() {
        isSelected.toggle()
    }
}
