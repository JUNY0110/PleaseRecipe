//
//  FloatingButton.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/13/24.
//

import UIKit

import SnapKit

final class FloatingButton: UIButton {
    
    // MARK: - Properties
    private var imageName: String = "plus" {
        didSet {
            configuration?.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable)
    override func draw(_ rect: CGRect) {
        isEnabled ? configureLayer(rect) : configureLayer() // shadow 그리기 : 지우기
    }
    
    // MARK: - Attribute
    private func attribute() {
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        configuration?.buttonSize = .large
    }
}


// MARK: - Configure
extension FloatingButton {
    func configureButton(
        systemName: String,
        foregroundColor: UIColor,
        backgroundColor: UIColor
    ) {
        self.imageName = systemName
        self.configuration?.baseForegroundColor = foregroundColor
        self.configuration?.background.backgroundColor = backgroundColor
    }
    
    private func configureLayer(_ rect: CGRect = .zero) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.secondaryLabel.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        
        /*
            문제: Dynamic Shadow는 렌더링에 버거운 동작.
            해결: shadowPath 또는 pre-Rendering으로 Layer 아래에 반영할 것.
         */
        let shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: rect.width / 2).cgPath
        layer.shadowPath = shadowPath   // dynamic Shadow 최적화
    }
}
