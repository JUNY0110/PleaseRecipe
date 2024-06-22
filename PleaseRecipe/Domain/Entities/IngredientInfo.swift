//
//  IngredientCategory.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/23/24.
//

import UIKit


enum IngredientInfo: MaterialProtocol {
    static var allCases: [IngredientInfo] {
        Vegetables.allCases.map(IngredientInfo.채소) + Pork.allCases.map(IngredientInfo.돼지고기) +
        Beef.allCases.map(IngredientInfo.소고기) + Chicken.allCases.map(IngredientInfo.닭고기) +
        Fruit.allCases.map(IngredientInfo.과일) + CanFood.allCases.map(IngredientInfo.통조림) +
        Seafood.allCases.map(IngredientInfo.해산물) + Minor.allCases.map(IngredientInfo.부재료) +
        Nut.allCases.map(IngredientInfo.견과류) + Condiment.allCases.map(IngredientInfo.조미료)
    }
    
    case 채소(Vegetables)
    case 돼지고기(Pork)
    case 소고기(Beef)
    case 닭고기(Chicken)
    case 과일(Fruit)
    case 통조림(CanFood)
    case 해산물(Seafood)
    case 부재료(Minor)
    case 견과류(Nut)
    case 조미료(Condiment)
    
    var category: IngredientSection {
        switch self {
        case .채소:
            return .채소
        case .돼지고기:
            return .돼지고기
        case .소고기:
            return .소고기
        case .닭고기:
            return .닭고기
        case .과일:
            return .과일
        case .통조림:
            return .통조림
        case .해산물:
            return .해산물
        case .부재료:
            return .부재료
        case .견과류:
            return .견과류
        case .조미료:
            return .조미료
        }
    }
    
    var image: UIImage {
        switch self {
        case .채소(let vegetables):
            return vegetables.image
        case .돼지고기(let pork):
            return pork.image
        case .소고기(let beef):
            return beef.image
        case .닭고기(let chicken):
            return chicken.image
        case .과일(let fruit):
            return fruit.image
        case .통조림(let canFood):
            return canFood.image
        case .해산물(let seafood):
            return seafood.image
        case .부재료(let minor):
            return minor.image
        case .견과류(let nut):
            return nut.image
        case .조미료(let condiment):
            return condiment.image
        }
    }
    
    var name: String {
        switch self {
        case .채소(let vegetables):
            return vegetables.name
        case .돼지고기(let pork):
            return pork.name
        case .소고기(let beef):
            return beef.name
        case .닭고기(let chicken):
            return chicken.name
        case .과일(let fruit):
            return fruit.name
        case .통조림(let canFood):
            return canFood.name
        case .해산물(let seafood):
            return seafood.name
        case .부재료(let minor):
            return minor.name
        case .견과류(let nut):
            return nut.name
        case .조미료(let seasonnings):
            return seasonnings.name
        }
    }
}
