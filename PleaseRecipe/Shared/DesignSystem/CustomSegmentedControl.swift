//
//  CustomSegmentedControl.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/29/24.
//

import UIKit

final class CustomSegmentedControl: UISegmentedControl {
    
    // MARK: Init
    override init(items: [Any]?) {
        super.init(items: items)
        
        attribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Attribute
    private func attribute() {
        backgroundColor = .storageSkyBlue
        layer.cornerRadius = 8
        
        removeDivider()
        selectedSegmentIndex()
        configureTextColor()
    }
}


// MARK: - Configure
extension CustomSegmentedControl {
    func selectedSegmentIndex(_ index: Int = 0) {
        selectedSegmentIndex = index
        
        configureTextColor()
    }
    
    private func configureTextColor() {
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ], for: .normal
        )
        
        guard let selectedSegment = SelectedSegment(rawValue: selectedSegmentIndex) else { return }
        configureTextColor(selectedSegment.color)
    }
    
    private func configureTextColor(_ color: UIColor) {
        self.setTitleTextAttributes(
          [
            NSAttributedString.Key.foregroundColor: color,
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
          ],
          for: .selected
        )
    }
    
    private func removeDivider() {
        let image = UIImage()
        
        self.setDividerImage(image,
                             forLeftSegmentState: .selected,
                             rightSegmentState: .normal,
                             barMetrics: .default)
    }
}

// MARK: - Nested Types
extension CustomSegmentedControl {
    private enum SelectedSegment: Int, CaseIterable {
        case first
        case second
        case third
        
        var color: UIColor {
            switch self {
            case .first:
                return .storageGreen
            case .second:
                return .storageBlue
            case .third:
                return .storageRed
            }
        }
    }
}
