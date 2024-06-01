//
//  MaterialCell.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/29/24.
//

import UIKit

import SnapKit


final class MaterialCell: UICollectionViewCell {
    
    // MARK: - Properities
    static let identifier = "MaterialCell"
    var image: UIImage?
    override var isSelected: Bool {
        didSet {
            configureSelected(isSelected)
        }
    }
    
    // MARK: - Views
    private let vStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 4
        return $0
    }(UIStackView())
    
    private let imageView: UIImageView = {
        $0.image = UIImage(systemName: "plus")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let nameLabel: UILabel = {
        $0.text = "테스트"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        
        addSubViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        nameLabel.text = ""
    }
    
    // MARK: - Attribute
    private func attribute() {
        self.layer.cornerRadius = 8
    }
    
    // MARK: - layout
    private func addSubViews() {
        contentView.addSubview(vStackView)
        vStackView.addArrangedSubview(imageView)
        vStackView.addArrangedSubview(nameLabel)
    }
    
    private func layout() {
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
}

// MARK: - Configure
extension MaterialCell {
    func configureCell(image: UIImage?, name: String = "") {
        imageView.image = image
        nameLabel.text = name
    }
    
    private func configureSelected(_ selected: Bool) {
        if selected {
            layer.borderColor = .init(red: 255/255, green: 148/255, blue: 148/255, alpha: 1)
            layer.borderWidth = 3
            
            image = imageView.image
        } else {
            layer.borderColor = .init(red: 255/255, green: 148/255, blue: 148/255, alpha: 0)
            layer.borderWidth = .zero
        }
    }
}
