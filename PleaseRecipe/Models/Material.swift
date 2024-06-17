//
//  Material.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/31/24.
//

import UIKit

struct Material: Hashable {
    var name: String        // 식품명
    var image: Data
    let registDate: Date?    // 등록일
    var useDate: Int        // 소비기한
    var category: MaterialCategory    // 식품분류 - 조미료, 식재료
    var storageType: String? // 저장방식 - 냉동 냉장 상온
}

enum MaterialCategory: String, CustomStringConvertible {
    case 식재료 = "  식재료"
    case 조미료 = "  조미료"
    
    var description: String {
        switch self {
        case .식재료:
            return "  식재료"
        case .조미료:
            return "  조미료"
        }
    }
}
