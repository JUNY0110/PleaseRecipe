//
//  HeaderCell.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/4/24.
//


import UIKit

import SnapKit

final class HeaderCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "HeaderCell"
    
    // MARK: - Views
    private let headerLabel: UILabel = {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        headerLabel.text = ""
    }
    
    // MARK: - Layout
    private func addSubviews() {
        contentView.addSubview(headerLabel)
    }
    
    private func layout() {
        headerLabel.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}


// MARK: - Configure
extension HeaderCell {
    func configureCell(_ text: String?) {
        headerLabel.text = text
    }
}
