//
//  IngredientSearchItem.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/30/24.
//

import Foundation

struct IngredientSearchItem: Hashable {
    let name: String
    let category: String
    var isSelected: Bool = false
    
    mutating func isSelectedToggle() {
        isSelected.toggle()
    }
}
