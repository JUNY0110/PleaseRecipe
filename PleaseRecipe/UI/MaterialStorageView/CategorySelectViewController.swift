//
//  CategorySelectViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/28/24.
//

import UIKit

import SnapKit

final class CategorySelectViewController: BaseViewController {
    
    // MARK: - Nested Types
    private enum Section {
        case section
    }
    
    // MARK: - Properties
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, IngredientSection>!
    private var currentIndex = 0
    var closure: (String) -> () = {_ in}
    
    // MARK: - Views
    private var collectionView: UICollectionView!
    
    // MARK: Attribute
    override func attribute() {
        super.attribute()
        
        configureNavigation()
        configureCollectionView()
        createDataSource()
        performSnapshot()
        selectedCategory()
    }
    
    // MARK: - Layout
    override func addSubviews() {
        view.addSubview(collectionView)
    }
    
    override func layout() {
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.bottom.equalToSuperview()
        }
    }
}


// MARK: - NavigationStyle
extension CategorySelectViewController: NavigationStyle {
    private func configureNavigation() {
        navigationItem.title = "식품 분류"
        rightBarButtonItem(systemName: "xmark", #selector(dismissViewController))
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}


// MARK: - Compositionable
extension CategorySelectViewController: Compositionable {
    func configureCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
    }
    
    func createDataSource() {
        let cellRegistration = cellRegistration()
        
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, IngredientSection>(collectionView: collectionView, cellProvider: { collectionView, indexPath, identifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
            
            return cell
        })
        
        collectionView.dataSource = diffableDataSource
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<IngredientCell, IngredientSection>{
        return UICollectionView.CellRegistration<IngredientCell, IngredientSection> { cell, indexPath, identifier in
            cell.configureCell(
                image: nil,
                name: identifier.title,
                pageType: .categorySelect
            )
        }
    }
    
    // Dynamic Cell 적용
    // cell의 길이에 따라 여백이 많이 남는 문제가 있음. -> 그리디 방식을 활용해 해결할 수 있을듯
    // 가로 크기, 가장 큰 cell들과 가장 작은 cell들.
    private func performSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, IngredientSection>()
        snapshot.appendSections([Section.section])
        snapshot.appendItems(IngredientSection.allCases)
        
        diffableDataSource.apply(snapshot)
    }
    

extension CategorySelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        closure(IngredientSection.allCases[indexPath.row].title)
    }
}
