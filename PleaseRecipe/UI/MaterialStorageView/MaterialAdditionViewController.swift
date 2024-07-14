//
//  MaterialAdditionViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/31/24.
//

import UIKit

import SnapKit

final class MaterialAdditionViewController: UIViewController, Navigationable {
    
    // MARK: - Properties
    typealias diffableDataSourceAlias = UICollectionViewDiffableDataSource<IngredientSection, IngredientItem>
    
    static let sectionHeaderElementKind = "SectionHeaderElementKind"
    private var diffableDataSource: diffableDataSourceAlias!
    private var snapshot: NSDiffableDataSourceSnapshot<IngredientSection, IngredientItem>!
    private var isShowingFloating = false
    private var selectedMaterials = [Item]() {
        didSet {
            configureFloatingStatus()
        }
    }
    
    private var sections: [IngredientSection: [IngredientItem]] = [
        .채소: [], .과일: [], .닭고기: [], .돼지고기: [], .소고기: [], .부재료: [], .통조림: [], .견과류: [], .조미료: []
    ]
    
    // MARK: - Views
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
    
    private var collectionView: UICollectionView!
    
    private lazy var dimView: UIView = {
        $0.backgroundColor = .white
        $0.alpha = 0
        $0.isUserInteractionEnabled = true
        
        let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(closeFloating))
        $0.addGestureRecognizer(tappedGesture)
        return $0
    }(UIView())
    
    private let vFloatingStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    private lazy var 보관레이어: FloatingHStack = {
        $0.configureMainLabel(style: .취소)
        $0.configureIsEnabled(isEnabled: false)
        $0.configureMainButton(style: .보관하기,
                               backgroundColor: .secondarySystemFill)
        $0.isHidden = false
        $0.addButtonAction(UIAction { [unowned self] action in self.controlFloating() })
        return $0
    }(FloatingHStack())
    
    private let 상온레이어: FloatingHStack = {
        $0.configureSubLabel(style: .상온보관)
        $0.configureIsEnabled(isEnabled: false)
        $0.configureSubButton(style: .상온보관,
                              foregroundColor: .storageRed)
        return $0
    }(FloatingHStack())
    
    private let 냉장레이어: FloatingHStack = {
        $0.configureSubLabel(style: .냉장보관)
        $0.configureIsEnabled(isEnabled: false)
        $0.configureSubButton(style: .냉장보관,
                              foregroundColor: .storageSkyBlue)
        return $0
    }(FloatingHStack())
    
    private let 냉동레이어: FloatingHStack = {
        $0.configureSubLabel(style: .냉동보관)
        $0.configureIsEnabled(isEnabled: false)
        $0.configureSubButton(style: .냉동보관,
                              foregroundColor: .storageBlue)
        return $0
    }(FloatingHStack())
    
    private lazy var floatingLayers: [FloatingHStack] = [보관레이어, 냉동레이어, 상온레이어, 냉장레이어]
    
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
        $0.addAction(UIAction { [unowned self] action in self.moveToRegistViewController() }, for: .touchUpInside)
        return $0
    }(UIButton(configuration: .plain()))
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        
        addSubviews()

    }
    
    // FIXME: UIKeyboarLayoutGuide를 적용한 화면에서 일부 버그가 발생하는 관계로, 임시로 viewWillAppear에 적용.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layout()
    }
    
    // MARK: - Attribute
    private func attribute() {
        view.backgroundColor = .systemBackground
        
        configureNavigation()
        configureCollectionView()
        createDataSource()
        performSnapshot()
        
        shouldHiddenCollectionView(sections.values.isEmpty)
    }
    
    // MARK: - Layout
    private func addSubviews() {
        view.addSubview(emptyTextLabel)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        view.addSubview(registButton)
        view.addSubview(dimView)
        view.addSubview(vFloatingStackView) // StackView 특성을 활용해 자연스러운 애니메이션 적용을 하기 위함.
        vFloatingStackView.addArrangedSubview(상온레이어)
        vFloatingStackView.addArrangedSubview(냉장레이어)
        vFloatingStackView.addArrangedSubview(냉동레이어)
        vFloatingStackView.addArrangedSubview(보관레이어)
    }
    
    private func layout() {
        let searchBarHeight = 50
        
        emptyTextLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-searchBarHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-searchBarHeight)
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(searchBarHeight)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        registButton.snp.makeConstraints {
            $0.height.equalTo(searchBarHeight)
            $0.left.equalTo(searchBar.snp.right)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.width.equalTo(100)
        }
        
        dimView.snp.makeConstraints {
            $0.edges.equalTo(view.snp.edges)
        }

        vFloatingStackView.snp.makeConstraints {
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalTo(searchBar.snp.top).offset(-16)
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
    
    private func controlFloating() {
        if isShowingFloating {
            closeFloating()    // 플로팅 닫기
        } else {
            openFloating()     // 플로팅 열기
        }
    }
    
    @objc private func closeFloating() {  // dim 인터렉션 비활성화 -> 메인버튼(보관레이어) 트랜지션 -> 서브버튼 숨김 애니메이션
        dimView.isUserInteractionEnabled = false // 추가 인터랙션 제한
        
        UIView.transition(
            with: 보관레이어.button,
            duration: 0.15,
            options: .transitionFlipFromLeft
        ) {
            self.보관레이어.configureMainButton(style: .보관하기)
        } completion: { finished in
            switch finished {
            case true:
                for i in self.floatingLayers.indices.reversed()  {
                    let stack = self.floatingLayers[i]
                    
                    self.dimView.alpha = 0
                    stack.alpha = 1
                    stack.spacing = 10
                    
                    UIView.animate(withDuration: 0.2) { // Floating 버튼 사라지는 애니메이션
                        stack.spacing = 0
                        stack.configureSubLabel(isHidden: true) // 모든 레이블 숨기는 동작
                        
                        if i != 0 {                          // 보관레이어는 동작에서 제외
                            stack.alpha = 0                  // 자연스럽게 사라지기 위한 설정
                            stack.isHidden = true            // 플로팅 버튼 숨기는 동작
                            stack.configureIsEnabled(isEnabled: false)
                        }
                    }
                }
                
                self.isShowingFloating = false // 플로팅이 완전히 사라졌을 때, false로 변환
            case false:
                // TODO: 알림창 띄우는 기능 필요
                debugPrint("알 수 없는 에러가 발생했습니다. 다시 시도해주세요")
                break
            }
        }
    }
    
    private func openFloating() { // 메인버튼(보관레이어) 트랜지션 -> 서브버튼 등장 애니메이션 -> dim 인터렉션 활성화, 햅틱 반응
        UIView.transition(
            with: 보관레이어.button,
            duration: 0.15,
            options: .transitionFlipFromLeft
        ) {
            self.보관레이어.configureMainButton(style: .취소)
        } completion: { finished in
            switch finished {
            case true:
                for i in self.floatingLayers.indices {
                    let stack = self.floatingLayers[i]
                    stack.alpha = (i == 0) ? 1 : 0 // 보관레이어는 동작에서 제외
                    stack.spacing = 0
                    stack.configureIsEnabled(isEnabled: true)
                    
                    UIView.animate(withDuration: 0.2) { // Floating 버튼 등장 애니메이션
                        self.dimView.alpha = 0.8
                        
                        stack.alpha = 1        // 자연스럽게 등장하기 위한 설정
                        stack.spacing = 10
                        stack.isHidden = false // 레이어가 등장하면서
                        
                        stack.configureSubLabel(isHidden: false) // 레이블이 등장하는 애니메이션
                    }
                }
                
                self.isShowingFloating = true                // 플로팅이 완전히 등장했을 때, true로 변환
                self.dimView.isUserInteractionEnabled = true // 전체 애니메이션 이후 인터랙션 사용
                self.generateHapticFeedback()                // 완전히 등장했다는 의미의 햅틱
            case false:
                // TODO: 알림창 띄우는 기능 필요
                debugPrint("알 수 없는 에러가 발생했습니다. 다시 시도해주세요")
                break
            }
        }
    }
    
    private func generateHapticFeedback() {
        // 성공적으로 Floating동작을 수행했음을 알리기 위한 햅틱
        let style = UIImpactFeedbackGenerator.FeedbackStyle.light
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func moveToRegistViewController() {
        let vc = MaterialRegistViewController()
        let text = searchBar.text
        vc.configureMaterialName(text ?? "")
        
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
    
    private func configureFloatingStatus() {
        if selectedMaterials.isEmpty {
            보관레이어.configureIsEnabled(isEnabled: false)
            보관레이어.configureMainButton(style: .보관하기,
                                      backgroundColor: .secondarySystemFill)
        } else {
            보관레이어.configureIsEnabled(isEnabled: true)
            보관레이어.configureMainButton(style: .보관하기,
                                      backgroundColor: .darkText)
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
        hideKeyboard()
        
        if let (sectionId, itemId) = self.findIndex(indexPath) {
            sections[sectionId]![itemId].isSelectedToggle()
            selectedMaterials.append(sections[sectionId]![itemId])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        hideKeyboard()
        
        if let (sectionId, itemId) = self.findIndex(indexPath) {
            sections[sectionId]![itemId].isSelectedToggle()
            selectedMaterials.removeAll(where: {$0.name == sections[sectionId]![itemId].name})
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboard()
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
    
    private func createDataSource() {
        let cellRegistration = cellRegistration()
        let headerRegistration = headerRegistration()
        
        // cellForRowAt과 같은 역할
        self.diffableDataSource = diffableDataSourceAlias(collectionView: collectionView, cellProvider: { collectionView, indexPath, material in
            
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: material
            )
            
            return cell
        })
        
        self.diffableDataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath
        ) -> UICollectionReusableView? in
            
            let headerView = collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
            
            return headerView
        }
        
        collectionView.dataSource = self.diffableDataSource
    }
    
    func performSnapshot(with searchText: String = "") {
        snapshot = NSDiffableDataSourceSnapshot<IngredientSection, IngredientItem>()
        
        for section in IngredientSection.allCases {
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
            
            let headerItem = snapshot.sectionIdentifiers[indexPath.section]
            headerView.configureCell(headerItem.title)
        }
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<MaterialCell, IngredientItem>{
        return UICollectionView.CellRegistration<MaterialCell, IngredientItem> { [unowned self] cell, indexPath, material in
            
            cell.configureCell(
                image: nil,
                name: material.name,
                pageType: .addtion
            )
            
            DispatchQueue.main.async {
                if let (sectionId, itemId) = self.findIndex(indexPath) {
                    let isSelected = self.sections[sectionId]![itemId].isSelected
                    cell.configureSelected(isSelected)
                }
            }
        }
    }
    
    private func findIndex(_ indexPath: IndexPath) -> (sectionId: IngredientSection, itemId: Int)? {
        let sectionId = snapshot.sectionIdentifiers[indexPath.section]
        let items = snapshot.itemIdentifiers(inSection: sectionId)
        let item = items[indexPath.item]
        
        guard let itemId = self.sections[sectionId]?.firstIndex(where: { $0.name == item.name }) else { return nil }
        
        return (sectionId, itemId)
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
