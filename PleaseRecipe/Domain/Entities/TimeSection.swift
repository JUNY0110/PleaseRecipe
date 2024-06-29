//
//  TimeSection.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/31/24.
//

import Foundation

// MARK: - Nested Types
extension MaterialRegistViewController {
    enum TimeSection: String, CaseIterable {
        case day = "일"
        case month = "월"
        case year = "년"
        
        var list: [Int] {
            switch self {
            case .day:
                return Array<Int>(1...30)
            case .month:
                return Array<Int>(1...11)
            case .year:
                return Array<Int>(1...20)
            }
        }
        
        var suffixString: String {
            switch self {
            case .day:
                return "일"
            case .month:
                return "개월"
            case .year:
                return "년"
            }
        }
    }
}
