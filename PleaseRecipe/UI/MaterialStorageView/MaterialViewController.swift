//
//  MaterialViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/29/24.
//

import UIKit

import SnapKit

final class MaterialViewController: BaseViewController {
    
    // MARK: - Properties
    private var diffableDataSource: UICollectionViewDiffableDataSource<MaterialSection, MaterialItem>!
    
    // MARK: Views
    private var collectionView: UICollectionView!
    
    // MARK: - Attribute
    @available(*, unavailable)
    override func attribute() {
        super.attribute()
        
        configureCollectionView()
        
        let cellRegistration = registCell()
        createDataSource(cellRegistration)
        performSnapshot()
    }
    
    // MARK: - Layout
    @available(*, unavailable)
    override func addSubviews() {
        view.addSubview(collectionView)
    }
    
    @available(*, unavailable)
    override func layout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


// MARK: - Compositionable
extension MaterialViewController: Compositionable {
    private func configureCollectionView() {
        let layout = createCompositionalLayout(columns: 4)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
}


// MARK: - Diffable CollectionView
extension MaterialViewController {
    private func createDataSource(_ cellRegistration: UICollectionView.CellRegistration<MaterialCell, MaterialItem>) {
        
        self.diffableDataSource = UICollectionViewDiffableDataSource<MaterialSection, MaterialItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, material in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: material)
        })
        
        collectionView.dataSource = diffableDataSource
    }
    
    private func performSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MaterialSection, MaterialItem>()
        snapshot.appendSections([.식재료, .조미료])
        
        snapshot.appendItems(Self.mock, toSection: .식재료)
        snapshot.appendItems(Self.mock2, toSection: .조미료)
        
        diffableDataSource.apply(snapshot)
    }
}

extension MaterialViewController {
    private func registCell() -> UICollectionView.CellRegistration<MaterialCell, MaterialItem>{
        
        return UICollectionView.CellRegistration<MaterialCell, MaterialItem> {cell,indexPath,material in
            
            cell.configureCell(image: UIImage(systemName: "plus"),
                               name: material.name,
                               pageType: .storage)
        }
    }
    ]
}
