//
//  MaterialAdditionViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/31/24.
//

import UIKit

import SnapKit

final class MaterialAdditionViewController: BaseViewController, Navigationable {
    
    // MARK: - Properties
    typealias diffableDataSourceAlias = UICollectionViewDiffableDataSource<분류, Item>
    
    static let sectionHeaderElementKind = "SectionHeaderElementKind"
    private var diffableDataSource: diffableDataSourceAlias!
    private var sections: [분류: [Item]] = [
        .채소: 채소.allCases.map { Item(name: $0.name, isSelected: false) },
        .과일: 과일.allCases.map { Item(name: $0.name, isSelected: false) },
        .닭고기: 닭고기.allCases.map { Item(name: $0.name, isSelected: false) },
        .돼지고기: 돼지고기.allCases.map { Item(name: $0.name, isSelected: false) },
        .소고기: 소고기.allCases.map { Item(name: $0.name, isSelected: false) },
        .부재료: 부재료.allCases.map { Item(name: $0.name, isSelected: false) },
        .통조림: 통조림.allCases.map { Item(name: $0.name, isSelected: false) },
        .견과류: 견과류.allCases.map { Item(name: $0.name, isSelected: false) },
        .조미료: 조미료.allCases.map { Item(name: $0.name, isSelected: false) },
    ]
    
    // MARK: - Nested Types
    struct Item: Hashable {
        let name: String
        var isSelected: Bool
    }
    
    // MARK: - Views
    private var collectionView: UICollectionView!
    
    private lazy var searchBar: CustomSearchBar = {
        $0.delegate = self
        return $0
    }(CustomSearchBar())
    
    private lazy var registButton: UIButton = {
        $0.configuration?.background.backgroundColor = .systemBackground
        $0.configuration?.baseForegroundColor = .mainRed
        $0.configuration?.title = "등록하기"
        $0.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 0
        $0.addAction(UIAction{[unowned self] action in self.moveToRegistViewController()}, for: .touchUpInside)
        return $0
    }(UIButton(configuration: .plain()))

    private let emptyTextLabel: UILabel = {
        $0.text = """
                  등록된 재료가 없습니다.
                  재료를 등록해주세요!
                  """
        $0.textAlignment = .center
        $0.textColor = .placeholderText
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    // MARK: - Attribute
    override func attribute() {
        super.attribute()
        
        configureNavigation()
        configureCollectionView()
        
        let headerRegistration = headerRegistration()
        let cellRegistration = cellRegistration()
        createDataSource(headerRegistration, cellRegistration)
        performSnapshot()

        shouldHiddenCollectionView(sections.values.isEmpty)
    }
    
    // MARK: - Layout
    override func addSubviews() {
        view.addSubview(emptyTextLabel)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        view.addSubview(registButton)
    }
    
    override func layout() {
        let searchBarHeight = 50
        
        emptyTextLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-searchBarHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-searchBarHeight) // searchBar 높이만큼 올리기
        }
        
        registButton.snp.makeConstraints {
            $0.height.equalTo(searchBarHeight)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(100)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(searchBarHeight)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(registButton.snp.left)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
}


// MARK: - NavigationBar
extension MaterialAdditionViewController {
    private func configureNavigation() {
        navigationItem.title = "식재료 찾기"
        backButtonItem()
        rightBarButtonItem(systemName: "xmark", #selector(dismissViewController))
    }
}


// MARK: - Methods
extension MaterialAdditionViewController {
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    private func moveToRegistViewController() {
        let vc = MaterialRegistViewController()
        let text = searchBar.text
        vc.configureMaterialName(text)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func shouldHiddenCollectionView(_ condition: Bool) {
        if condition {
            collectionView.isHidden = true
            emptyTextLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            emptyTextLabel.isHidden = true
        }
    }
}


// MARK: - Keyboardable
extension MaterialAdditionViewController: Keyboardable {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MaterialAdditionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
        
        configureItem(of: indexPath, isSelected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        configureItem(of: indexPath, isSelected: false)
    }
    
    private func configureItem(of indexPath: IndexPath, isSelected: Bool) {
        let snapshot = diffableDataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        let items = snapshot.itemIdentifiers(inSection: section)
        let item = items[indexPath.item]
        
        guard let itemIndex = sections[section]?.firstIndex(where: {
            $0.name == item.name
        }) else { return }
        
        sections[section]![itemIndex].isSelected = isSelected // 인덱스의 값이므로, 반드시 존재.
    }
}

// MARK: - Diffable CollectionView
extension MaterialAdditionViewController: Compositionable {
    private func configureCollectionView() {
        let layout = createCompositionalLayout(columns: 2,
                                               height: 40,
                                               headerElementKind: Self.sectionHeaderElementKind)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
    }
    
    private func createDataSource(
        _ headerRegistration: UICollectionView.SupplementaryRegistration<HeaderCell>,
        _ cellRegistration: UICollectionView.CellRegistration<MaterialCell, Item>
    ) {
        // cellForItem과 같은 역할
        self.diffableDataSource = diffableDataSourceAlias(collectionView: collectionView, cellProvider: { collectionView, indexPath, material in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: material)
        })
        
        self.diffableDataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let headerView = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            
            return headerView
        }
        
        collectionView.dataSource = self.diffableDataSource
    }
    
    private func performSnapshot(with searchText: String? = "") {
        var snapshot = NSDiffableDataSourceSnapshot<분류, Item>()

        for section in 분류.allCases {
            guard let items = sections[section] else { continue }
            
            // 검색이 비어있으면, 전체 보여주기
            if searchText == ""  {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
                continue
            }
            
            // 검색데이터 필터링.
            let filteredMaterials = items.filter { item in
                item.name.contains(searchText ?? "")
            }
            
            // 검색한 재료가 있는 섹션은, 재료를 보여준다.
            snapshot.appendSections([section])
            snapshot.appendItems(filteredMaterials, toSection: section)
        }
        
        diffableDataSource.apply(snapshot)
    }
}

extension MaterialAdditionViewController {
    private func headerRegistration() -> UICollectionView.SupplementaryRegistration<HeaderCell>{
        return UICollectionView.SupplementaryRegistration<HeaderCell>(elementKind: Self.sectionHeaderElementKind){ [unowned self] headerView, elementKind, indexPath in
            
            let headerItem = self.diffableDataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView.configureCell(headerItem.name)
        }
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<MaterialCell, Item>{
        return UICollectionView.CellRegistration<MaterialCell, Item> { cell, indexPath, material in
            
            cell.configureCell(image: nil,
                               name: material.name,
                               pageType: .addtion)
            
            cell.configureSelected(material.isSelected)
        }
    }
}

// MARK: - UISearchBarDelegate
extension MaterialAdditionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchText = searchText.lowercased()                        // 대소문자 무시
        searchText = searchText.replacingOccurrences(of: " ", with: "") // 띄어쓰기 무시
        performSnapshot(with: searchText)
    }
}


/*
    ** 문제상황 **
    1. diffableDataSource를 사용하면 보여지는 cell이 초기화되는 문제가 있다.
        - diffableDataSource는 화면이 수정되는게 아니라면, 새로 그려낸다.
        - 화면 상의 위치만 바뀐다면, 기존의 데이터를 사용한다.
    2. 실제 cell의 isSelected가 초기화되는 것과는 다르다.
        - cell의 isSelected는 유지된다. print(cell.isSelected)를 통해 확인
        - 따라서, cell을 보여주는 것에서 유지되지 않는다.
    
    ** 해결 **
    1. didSelectItemAt메서드의 indexPath를 통해 현재 선택한 cell의 정보 추출
        (section -> items -> item)
    2. cell의 item.name과 동일한 정보를 가진 데이터목록(sections)의 item을 찾는다.
    3. 해당 아이템의 index정보를 이용해 sections에 isSelected 정보를 수정한다.
    4. sections의 item정보를 이용해 화면이 새로 그려져도 선택한 정보는 유지된다.
 */
