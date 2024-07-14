//
//  IngredientStorageItem.swift
//  PleaseRecipe
//
//  Created by 지준용 on 7/14/24.
//

import Foundation


struct IngredientStorageItem: Hashable {  // CollectionView Item
    let image: Data?
    var storageType: String?   // 냉동, 냉장, 상온
    var name: String
    let registDate: Date?      // 오늘 날짜
    var useDate: Int           // 소비기한. 오늘로부터 며칠인지.
    let category: String       // 식재료, 조미료
}

