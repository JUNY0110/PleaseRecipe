//
//  IngredientSection.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/20/24.
//

import UIKit


enum IngredientSection: String, CaseIterable, Hashable {
    case 채소
    case 돼지고기
    case 소고기
    case 닭고기
    case 과일
    case 통조림
    case 해산물
    case 부재료
    case 견과류
    case 조미료
    
    var title: String {
        return self.rawValue
    }
}
