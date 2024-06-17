//
//  AttributedString+Extension.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/30/24.
//

import UIKit


extension AttributedString {
    static func configureTitle(_ button: ButtonType, size: CGFloat, weight: UIFont.Weight) -> Self? {
        var stringAttr = Self.init(button.text)
        stringAttr.font = .systemFont(ofSize: size, weight: weight)
        
        return stringAttr
    }
}

enum ButtonType: String {
    case addition = "목록에 추가하기"
    case cancel = "취소"
    
    var text: String {
        switch self {
        case .addition:
            return "목록에 추가하기"
        case .cancel:
            return "취소"
        }
    }
}
