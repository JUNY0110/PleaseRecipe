//
//  UseDate.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/27/24.
//

import Foundation

enum UseDate: String {
    case oneDay = "1일"
    case threeDay = "3일"
    case oneWeek = "7일"
    case twoWeek = "14일"
    case directSetting = "직접 설정"
    
    var text: String {
        return self.rawValue
    }
}
