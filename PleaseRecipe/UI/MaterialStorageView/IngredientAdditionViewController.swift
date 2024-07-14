//
//  IngredientAdditionViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/31/24.
//

import UIKit

import SnapKit


final class IngredientAdditionViewController: BaseViewController, Navigationable {
    
    // MARK: - Properties
    typealias diffableSection = IngredientSection
    typealias diffableItem = IngredientSearchItem
    
    static let sectionHeaderElementKind = "SectionHeaderElementKind"
    private var diffableDataSource: UICollectionViewDiffableDataSource<diffableSection, diffableItem>!
    private var snapshot: NSDiffableDataSourceSnapshot<diffableSection, diffableItem>!
    private var isShowingFloating = false
    private let coredataManager = CoreDataManager.shared
    private var datum: [diffableItem] = []
    
    private var selectedIngredients = [diffableItem]() {
        didSet {
            configureFloatingStatus()
        }
    }
    
    var completion: (diffableItem, StorageType) -> () = {(_, _) in}
    
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
        $0.delegate = self
        return $0
    }(FloatingHStack())
    
    private lazy var 상온레이어: FloatingHStack = {
        $0.configureSubLabel(style: .상온보관)
        $0.configureIsEnabled(isEnabled: false)
        $0.configureSubButton(style: .상온보관,
                              foregroundColor: .storageRed)
        $0.delegate = self
        return $0
    }(FloatingHStack())
    
    private lazy var 냉장레이어: FloatingHStack = {
        $0.configureSubLabel(style: .냉장보관)
        $0.configureIsEnabled(isEnabled: false)
        $0.configureSubButton(style: .냉장보관,
                              foregroundColor: .storageSkyBlue)
        $0.delegate = self
        return $0
    }(FloatingHStack())
    
    private lazy var 냉동레이어: FloatingHStack = {
        $0.configureSubLabel(style: .냉동보관)
        $0.configureIsEnabled(isEnabled: false)
        $0.configureSubButton(style: .냉동보관,
                              foregroundColor: .storageBlue)
        $0.delegate = self
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideKeyboard()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    // MARK: - Attribute
    @available(*, unavailable)
    override func attribute() {
        super.attribute()
        
        datum = coredataManager.fetchIngredientSearchItem()
        
        configureNavigation()
        configureCollectionView()
        createDataSource()
        performSnapshot()
        registerKeyboardNotification()
        
        shouldHiddenCollectionView(datum.isEmpty)
    }
    
    // MARK: - Layout
    @available(*, unavailable)
    override func addSubviews() {
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
    
    @available(*, unavailable)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-searchBarHeight)
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(searchBarHeight)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        registButton.snp.makeConstraints {
            $0.height.equalTo(searchBarHeight)
            $0.left.equalTo(searchBar.snp.right)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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


// MARK: - Navigation
extension IngredientAdditionViewController {
    private func configureNavigation() {
        navigationItem.title = "식재료 찾기"
        
        backButtonItem()
        rightBarButtonItem(systemName: "xmark", #selector(dismissViewController))
    }
    
    private func moveToRegistViewController() {
        let vc = IngredientRegistViewController()
        let text = searchBar.text
        vc.configureIngredientName(text ?? "")
        vc.storeIngredientNames(datum.map { $0.name } )
        vc.completion = { item in
            self.datum.append(item)
            self.datum.sort(by: {$0.name < $1.name})
            
            self.collectionView.reloadData()
            self.performSnapshot()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}


// MARK: - Keyboard Observer
extension IngredientAdditionViewController {
    private func findSafeAreaBottomInset() -> CGFloat {
        guard let safeAreaBottom = windowScene?.keyWindow?.safeAreaInsets.bottom else { return 0 }
        
        return safeAreaBottom
    }
    
    @objc private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let safeAreaBottomInset = findSafeAreaBottomInset()
            let keyboardHeight = -keyboardFrame.height+safeAreaBottomInset
            UIView.animate(withDuration: 0.3) {
                self.searchBar.transform = CGAffineTransform(translationX: 0, y: keyboardHeight)
                self.registButton.transform = CGAffineTransform(translationX: 0, y: keyboardHeight)
                self.vFloatingStackView.transform = CGAffineTransform(translationX: 0, y: keyboardHeight)
                self.collectionView.transform = CGAffineTransform(translationX: 0, y: keyboardHeight)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.searchBar.transform = .identity
        self.registButton.transform = .identity
        self.vFloatingStackView.transform = .identity
        self.collectionView.transform = .identity
    }
}


// MARK: - Floating
extension IngredientAdditionViewController: FloatingHstackDelegate {
    func touchButton(action: UIAction, label: UILabel) {
        if let text = label.text,
           let style = StorageType(rawValue: text) {
            
            selectedIngredients.forEach { ingredient in
                coredataManager.storeIngredient(name: ingredient.name, storage: style.text)
                completion(ingredient, style)
            }
            
            closeFloating()
        } else {
            isShowingFloating ? closeFloating() : openFloating()
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
                            stack.disappear(isAlpha: true)
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

    private func configureFloatingStatus() {
        if selectedIngredients.isEmpty {
            보관레이어.configureIsEnabled(isEnabled: false)
            보관레이어.configureMainButton(style: .보관하기,
                                      backgroundColor: .secondarySystemFill)
        } else {
            보관레이어.configureIsEnabled(isEnabled: true)
            보관레이어.configureMainButton(style: .보관하기,
                                      backgroundColor: .darkText)
        }
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
extension IngredientAdditionViewController: Keyboardable {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension IngredientAdditionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
        hideKeyboard()
        
        if let itemId = self.findIndex(indexPath) {
            datum[itemId].isSelectedToggle()
            selectedIngredients.append(datum[itemId])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        hideKeyboard()
        
        if let itemId = self.findIndex(indexPath) {
            datum[itemId].isSelectedToggle()
            selectedIngredients.removeAll(where: {$0.name == datum[itemId].name})
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
}


// MARK: - Diffable CollectionView
extension IngredientAdditionViewController: Compositionable {
    func configureCollectionView() {
        let layout = createCompositionalLayout(columns: 2,
                                               height: 40,
                                               headerElementKind: Self.sectionHeaderElementKind)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    func createDataSource() {
        let cellRegistration = cellRegistration()
        let headerRegistration = headerRegistration()
        
        // cellForRowAt과 같은 역할
        self.diffableDataSource = UICollectionViewDiffableDataSource<diffableSection, diffableItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, ingredient in
            
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: ingredient
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
        snapshot = NSDiffableDataSourceSnapshot<diffableSection, diffableItem>()
        
        // section 순서로 재료를 분류하기 위함.
        for section in diffableSection.allCases {
            snapshot.appendSections([section])
            
            for data in datum where data.category == section.title {
                // 검색이 비어있으면, 전체 보여주기
                if searchText == "" {
                    snapshot.appendItems([data], toSection: section)
                    continue
                }
                
                // 검색어를 포함하는 재료명만
                if data.name.contains(searchText) {
                    snapshot.appendItems([data], toSection: section)
                }
            }
            
            // item이 없는 section 제거.
            if snapshot.numberOfItems(inSection: section) == 0 {
                snapshot.deleteSections([section])
            }
        }
        
        diffableDataSource.apply(snapshot)
    }
}

extension IngredientAdditionViewController {
    private func headerRegistration() -> UICollectionView.SupplementaryRegistration<HeaderCell>{
        return UICollectionView.SupplementaryRegistration<HeaderCell>(elementKind: Self.sectionHeaderElementKind){ [unowned self] headerView, elementKind, indexPath in
            
            let headerItem = snapshot.sectionIdentifiers[indexPath.section]
            headerView.configureCell(headerItem.title)
        }
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<IngredientCell, diffableItem>{
        return UICollectionView.CellRegistration<IngredientCell, diffableItem> { [unowned self] cell, indexPath, ingredient in
            
            cell.configureCell(
                image: nil,
                name: ingredient.name,
                pageType: .addition
            )
            
            DispatchQueue.main.async {
                if let itemId = self.findIndex(indexPath) {
                    let isSelected = self.datum[itemId].isSelected
                    cell.configureSelected(isSelected)
                }
            }
        }
    }
    
    private func findIndex(_ indexPath: IndexPath) -> Int? {
        let sectionId = snapshot.sectionIdentifiers[indexPath.section]
        let items = snapshot.itemIdentifiers(inSection: sectionId)
        let item = items[indexPath.item]
        guard let itemId = datum.firstIndex(of: item) else { return nil }
        
        return itemId
    }
    
    @objc private func longPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let indexPath = collectionView.indexPathForItem(at: sender.location(in: self.collectionView)) else { return }
            let section = indexPath.section
            let row = indexPath.row
            let category = diffableSection.allCases[section]
            
            let item = datum.filter({$0.category == category.title})[row]
            let name = item.name
            
            showAlert(title: "안내 메시지",
                      message: """
                               삭제 시, 보관 중인 재료에서도 사라집니다.
                               \(name)을/를 삭제하시겠습니까?
                               """,
                      yesHandler: { [weak self] yesAction in
                guard let self = self else { return }
                
                // TODO: Repository와 ViewModel(Reactor)로 구조를 분리하고, 데이터를 하나로 관리하도록 수정.
                self.datum.remove(at: row) // 보여지는 데이터. Diffable 새로고침용. 선택된 cell 중, 마지막으로 선택한 재료를 제거함.
                self.coredataManager.deleteIngredient(name) // 실제 재료 데이터 소거.
                
                StorageType.allCases.forEach { type in
                    self.completion(item, type)
                }
                
                self.performSnapshot()
                
                removeSelectedIngredient(name)
            })
        }
    }
    
    private func removeSelectedIngredient(_ name: String) {
        guard let index = self.selectedIngredients.firstIndex(where: {$0.name == name}) else { return }
        self.selectedIngredients.remove(at: index)
    }
}


// MARK: - UISearchBarDelegate
extension IngredientAdditionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.replacingOccurrences(of: " ", with: "") // 띄어쓰기 무시
        
        performSnapshot(with: searchText)
    }
}
