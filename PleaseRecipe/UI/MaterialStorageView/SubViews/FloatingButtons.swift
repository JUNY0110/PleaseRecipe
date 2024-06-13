//
//  FloatingButtons.swift
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
    
    // MARK: - Attribute
    private func attribute() {
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        configuration?.buttonSize = .large
        
        layer.shadowColor = UIColor.secondaryLabel.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
    }
    
    // MARK: - Configure
    func configureMainButton(
        systemName: String,
        foregroundColor: UIColor,
        backgroundColor: UIColor
    ) {
        self.imageName = systemName
        self.configuration?.baseForegroundColor = foregroundColor
        self.configuration?.background.backgroundColor = backgroundColor
    }
    
    func configureSubButton(
        systemName: String,
        foregroundColor: UIColor,
        backgroundColor: UIColor
    ) {
        self.imageName = systemName
        self.configuration?.baseForegroundColor = foregroundColor
        self.configuration?.background.backgroundColor = backgroundColor
    }
}
