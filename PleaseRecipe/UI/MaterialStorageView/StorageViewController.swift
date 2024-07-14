//
//  StorageViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/29/24.
//

import UIKit

import SnapKit

final class StorageViewController: BaseViewController {
    
    // MARK: - Properties
    private var diffableDataSource: UICollectionViewDiffableDataSource<IngredientStorageSection, IngredientStorageItem>!
    private let coredataManager = CoreDataManager.shared
    private let storage: StorageType
    
    // MARK: Views
    private var collectionView: UICollectionView!
    private lazy var emptyTextLabel: UILabel = {
        $0.text = """
                  \(storage.text)보관 중인 재료가 없습니다.
                  + 버튼을 눌러 재료를 추가해주세요.
                  """
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel())
    
    // MARK: - Init
    init(storage: StorageType) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Attribute
    @available(*, unavailable)
    override func attribute() {
        super.attribute()
        
        configureCollectionView()
        createDataSource()
        performSnapshot()
    }
    
    // MARK: - Layout
    @available(*, unavailable)
    override func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(emptyTextLabel)
    }
    
    @available(*, unavailable)
    override func layout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        emptyTextLabel.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


// MARK: - Compositionable
extension StorageViewController: Compositionable {
    func configureCollectionView() {
        let layout = createCompositionalLayout(columns: 4)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    func createDataSource() {
        let cellRegistration = registCell()
        
        self.diffableDataSource = UICollectionViewDiffableDataSource<IngredientStorageSection, IngredientStorageItem>(
            collectionView: collectionView, cellProvider: { collectionView, indexPath, ingredient in
                
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: ingredient
                )
            }
        )
        
        collectionView.dataSource = diffableDataSource
    }
}


// MARK: - Diffable CollectionView
extension StorageViewController {
    func performSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<IngredientStorageSection, IngredientStorageItem>()
        snapshot.appendSections([.section])
        
        let storedItems = coredataManager.fetchStoredIngredients(storage.text)
        
        shouldHiddenLabel(storedItems) { isHidden in
            guard isHidden else { return }
            snapshot.appendItems(storedItems)
            
            diffableDataSource.apply(snapshot)
        }
    }
    
    private func shouldHiddenLabel(_ items: [IngredientStorageItem], completion: (Bool) -> ()) {
        emptyTextLabel.isHidden = items.isEmpty ? false : true
        completion(emptyTextLabel.isHidden)
    }
}

extension StorageViewController {
    private func registCell() -> UICollectionView.CellRegistration<IngredientCell, IngredientStorageItem>{
        
        return UICollectionView.CellRegistration<IngredientCell, IngredientStorageItem> {cell, indexPath, ingredient in
            guard let imageData = ingredient.image else { return }
            
            cell.configureCell(image: UIImage(data: imageData),
                               name: ingredient.name,
                               pageType: .storage)
        }
    }
}
