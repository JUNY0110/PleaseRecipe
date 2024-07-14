//
//  TransitionButtonStyle.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/30/24.
//

import Foundation

// MARK: - Nested Types
enum TransitionButtonStyle {
    case 취소
    case 보관하기
    
    var imageName: String {
        switch self {
        case .취소:
            return "xmark"
        case .보관하기:
            return "refrigerator.fill"
        }
    }
    
    var text: String {
        switch self {
        case .취소:
            return "취소"
        case .보관하기:
            return ""
        }
    }
}
