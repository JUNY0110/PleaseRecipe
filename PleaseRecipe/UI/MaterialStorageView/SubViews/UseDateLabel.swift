//
//  UseDateLabel.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/26/24.
//

import UIKit

protocol UseDateLabelDelegate: AnyObject {
    func selectedLabel(_ useDateLabel: UseDateLabel)
}

final class UseDateLabel: CustomRoundLabel {
    
    // MARK: Properties
    weak var delegate: UseDateLabelDelegate?
    var isSelected: Bool = false {
        didSet {
            selectLabel()
        }
    }
    
    // MARK: - Init
    init(frame: CGRect = .zero, useDate: UseDate) {
        super.init(frame: frame)
        
        configureLabel(useDate.text)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedLabel))
        addGestureRecognizer(tapGesture)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectedLabel() {
        if !isSelected {
            delegate?.selectedLabel(self) // 이미 선택된 탭 클릭 시, 연산 최소화
        }
    }
}

extension UseDateLabel {
    private func configureLabel(_ text: String) {
        self.text = text
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.backgroundColor = .systemBackground
        self.isUserInteractionEnabled = true
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    private func selectLabel() {
        if isSelected {
            layer.borderColor = UIColor.clear.cgColor
            backgroundColor = .mainRed
            textColor = .white
        } else {
            layer.borderColor = UIColor.systemGray5.cgColor
            backgroundColor = .white
            textColor = .black
        }
    }
}
