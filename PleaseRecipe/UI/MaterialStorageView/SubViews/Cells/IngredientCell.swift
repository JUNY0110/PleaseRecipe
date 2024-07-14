//
//  IngredientCell.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/29/24.
//

import UIKit

import SnapKit


final class IngredientCell: UICollectionViewCell {
    
    // MARK: - Properities
    static let identifier = "IngredientCell"
    var image: UIImage?
    
    private lazy var pageType: PageType = .storage {
        didSet {
            switch pageType {
            case .storage:
                break
            case .addition:
                imageView.isHidden = true
                nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            case .regist:
                nameLabel.isHidden = true
            }
        }
    }
    
    override var isSelected: Bool {
        willSet {
            configureSelected(newValue)
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
        return $0
    }(UILabel())
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        
        addSubViews()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable)
    override func prepareForReuse() {
        imageView.image = nil
        nameLabel.text = ""
    }
    
    // MARK: - Attribute
    private func attribute() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        self.contentView.layer.borderWidth = 1
        
    }
    
    // MARK: - Layout
    private func addSubViews() {
        contentView.addSubview(vStackView)
        vStackView.addArrangedSubview(imageView)
        vStackView.addArrangedSubview(nameLabel)
    }
    
    private func layout() {
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(nameLabel.intrinsicContentSize.height).priority(.high)
        }
    }
}

// MARK: - Configure
extension IngredientCell {
    func configureCell(image: UIImage?, name: String = "", pageType: PageType) {
        self.pageType = pageType
        self.imageView.image = image
        self.nameLabel.text = name
    }
    
    func configureSelected(_ isSelected: Bool) {
        if isSelected {
            UIView.animate(withDuration: 0.1, delay: .zero, options: .curveEaseInOut) {
                self.contentView.layer.borderColor = UIColor.mainRed.cgColor
                self.contentView.layer.borderWidth = 2
            }

            image = imageView.image
        } else {
            UIView.animate(withDuration: 0.1, delay: .zero, options: .curveEaseInOut) {
                self.contentView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
                self.contentView.layer.borderWidth = 1
            }
        }
    }
}


// MARK: - Nested Types
extension IngredientCell {
    enum PageType {
        case storage
        case addition
        case regist
    }
}
