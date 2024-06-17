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
        case none = "무기한"
        case day = "일"
        case month = "월"
        case year = "년"
        
        var list: [Int] {
            switch self {
            case .none:
                return [0]
            case .day:
                return Array<Int>(0...30)
            case .month:
                return Array<Int>(0...11)
            case .year:
                return Array<Int>(0...20)
            }
        }
    }
}
