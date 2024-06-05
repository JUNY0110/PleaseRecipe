//
//  MaterialCell.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/29/24.
//

import UIKit

import SnapKit

enum PageType {
    case storage
    case addtion
    case regist
}

final class MaterialCell: UICollectionViewCell {
    
    // MARK: - Properities
    static let identifier = "MaterialCell"
    var image: UIImage?
    
    private var pageType: PageType = .storage {
        didSet {
            // TODO: isHidden을 다시 안 바꿔도 괜찮은지 확인을 위한 TODO 주석
            switch pageType {
            case .storage:
                break
            case .addtion:
                imageView.isHidden = true
                nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            case .regist:
                nameLabel.isHidden = true
            }
        }
    }
    
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
    
    private lazy var imageView: UIImageView = {
        $0.image = UIImage(systemName: "plus")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var nameLabel: UILabel = {
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
        self.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        self.layer.borderWidth = 1
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
    }
}

// MARK: - Configure
extension MaterialCell {
    func configureCell(image: UIImage?, name: String = "", pageType: PageType) {
        imageView.image = image
        nameLabel.text = name
        self.pageType = pageType
    }
    
    func configureSelected(_ selected: Bool) {
        if selected {
            layer.borderColor = UIColor.mainRed.cgColor
            layer.borderWidth = 3
            
            image = imageView.image
        } else {
            layer.borderColor = UIColor.secondarySystemBackground.cgColor
            layer.borderWidth = 1
        }
    }
}
