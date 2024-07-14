//
//  StorageType.swift
//  PleaseRecipe
//
//  Created by 지준용 on 7/12/24.
//

import Foundation


enum StorageType: String, CaseIterable {
    case 냉동보관 = "냉동"
    case 냉장보관 = "냉장"
    case 상온보관 = "상온"
    
    var imageName: String {
        switch self {
        case .냉동보관:
            return "snowflake"
        case .냉장보관:
            return "snowflake"
        case .상온보관:
            return "snowflake_slash"
        }
    }
    
    var text: String {
        return self.rawValue
    }
}

