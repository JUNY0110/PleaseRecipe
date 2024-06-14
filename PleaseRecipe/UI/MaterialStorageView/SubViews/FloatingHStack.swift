//
//  FloatingHStack.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/13/24.
//

import UIKit

import SnapKit

final class FloatingHStack: UIStackView {
    
    // MARK: - Views
    private let label: UILabel = {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private let button = FloatingButton()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        
        addSubviews()
        layout()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Attribute
    private func attribute() {
        axis = .horizontal
    }
    
    // MARK: - Layout
    private func addSubviews() {
        addArrangedSubview(label)
        addArrangedSubview(button)
    }
    
    private func layout() {
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}


// MARK: - Configure
extension FloatingHStack {
    func configureLabel(_ buttonStyle: FloatingButtonStyle) {
        label.text = buttonStyle.text
    }
    
    func configureIsEnabled(isEnabled: Bool = true) {
        button.isEnabled = isEnabled
    }
    
    func configureMainButton(
        systemName: FloatingButtonStyle,
        foregroundColor: UIColor = .white,
        backgroundColor: UIColor = .darkText
    ) {
        button.configureButton(
            systemName: systemName.imageName,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor
        )
    }
    
    func configureSubButton(
        systemName: FloatingButtonStyle,
        foregroundColor: UIColor,
        backgroundColor: UIColor = .white
    ) {
        button.configureButton(
            systemName: systemName.imageName,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor
        )
    }
}

// MARK: - Methods
extension FloatingHStack {
    func addButtonAction(_ action: UIAction) {
        button.addAction(action, for: .touchUpInside)
    }
}

// MARK: - Nested Types
extension FloatingHStack {
    enum FloatingButtonStyle {
        case 냉동보관
        case 냉장보관
        case 상온보관
        case 취소
        case 보관하기
        
        var imageName: String {
            switch self {
            case .냉동보관:
                return "snowflake"
            case .냉장보관:
                return "snowflake"
            case .상온보관:
                return "snowflake.slash"
                
            case .취소:
                return "xmark"
            case .보관하기:
                return "refrigerator.fill"
            }
        }
        
        var text: String {
            switch self {
            case .냉동보관:
                return "냉동"
            case .냉장보관:
                return "냉장"
            case .상온보관:
                return "상온"
                
            case .취소:
                return "취소"
            case .보관하기:
                return ""
            }
        }
    }
}
