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
    
    let button = FloatingButton()
    
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
        isHidden = true
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
    func configureMainLabel(
        style: TransitionButtonStyle? = nil,
        isHidden: Bool = true
    ) {
        label.text = style?.text ?? label.text // 버튼 최초 사용 시, 저장된 text를 사용.
        label.isHidden = isHidden
    }
    
    func configureSubLabel(
        style: FloatingButtonStyle? = nil,
        isHidden: Bool = true
    ) {
        label.text = style?.text ?? label.text // 버튼 최초 사용 시, 저장된 text를 사용.
        label.isHidden = isHidden
    }
    
    func configureIsEnabled(isEnabled: Bool = true) {
        button.isEnabled = isEnabled
    }
    
    func configureMainButton(
        style: TransitionButtonStyle,
        foregroundColor: UIColor = .white,
        backgroundColor: UIColor = .darkText
    ) {
        button.configureButton(
            imageName: style.imageName,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor
        )
    }
    
    func configureSubButton(
        style: FloatingButtonStyle,
        foregroundColor: UIColor,
        backgroundColor: UIColor = .white
    ) {
        button.configureButton(
            imageName: style.imageName,
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
    
    enum FloatingButtonStyle {
        case 냉동보관
        case 냉장보관
        case 상온보관
        
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
            switch self {
            case .냉동보관:
                return "냉동"
            case .냉장보관:
                return "냉장"
            case .상온보관:
                return "상온"
            }
        }
    }
}
