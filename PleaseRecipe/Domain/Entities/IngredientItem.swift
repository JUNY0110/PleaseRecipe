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
    let useDate: Int32
    let category: String
    var isSelected: Bool = false
    
    mutating func isSelectedToggle() {
        isSelected.toggle()
    }
}
