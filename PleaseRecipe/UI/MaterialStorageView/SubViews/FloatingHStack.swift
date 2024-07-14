//
//  FloatingHStack.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/13/24.
//

import UIKit

import SnapKit

protocol FloatingHstackDelegate: AnyObject {
    func touchButton(action: UIAction, label: UILabel)
}

final class FloatingHStack: UIStackView {
    
    weak var delegate: FloatingHstackDelegate?
    
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
        
        addArrangedSubviews()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Attribute
    private func attribute() {
        axis = .horizontal
        isHidden = true
        
        button.addAction(UIAction(handler: { [unowned self] action in self.touchButton(action)}), for: .touchUpInside)
    }
    
    // MARK: - Layout
    private func addArrangedSubviews() {
        addArrangedSubview(label)
        addArrangedSubview(button)
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
        style: StorageType? = nil,
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
        style: StorageType,
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
    
    func touchButton(_ action: UIAction) {
        delegate?.touchButton(action: action, label: label)
    }
}
