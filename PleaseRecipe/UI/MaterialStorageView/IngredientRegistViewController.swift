//
//  IngredientRegistViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/30/24.
//

import UIKit

import SnapKit


final class IngredientRegistViewController: BaseViewController, NavigationStyle {
    
    // MARK: - Properties
    private let time = TimeSection.allCases
    private var ingredientNames = [String]()
    private var sectionRow = 0
    private var itemRow = 0
    private var registeringItem: IngredientRegisterRequestDTO = .init(image: nil, name: "", useDate: 0, category: "기타")
    private let coredataManager = CoreDataManager.shared
    private var useDateCache = 1
    private var list: [Int] = [1]
    var completion: (IngredientSearchItem) -> () = { _ in }
    
    // MARK: - Views
    private let imageSelectionLabel: UILabel = {
        $0.text = "이미지 선택"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return $0
    }(UILabel())
    
    // 이미지 셀
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        $0.collectionViewLayout = flowLayout
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    private let containerView = UIView()
    
    private lazy var ingredientNameTextField: UITextField = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.backgroundColor = .secondarySystemFill
        $0.placeholder = "예시) 매실"
        $0.borderStyle = .roundedRect
        $0.autocorrectionType = .no
        $0.enablesReturnKeyAutomatically = true
        $0.clearButtonMode = .whileEditing
        $0.delegate = self
        $0.addAction(UIAction{ [unowned self] action in self.editingAdditionButtonStatus() }, for: .editingChanged)
        
        let space = UIView()
        $0.leftView = space
        $0.leftViewMode = .always
        return $0
    }(UITextField())
    
    // 소비기한(레이블, 토글)
    private let useDateTopHStack: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.backgroundColor = .systemBackground
        return $0
    }(UIStackView())
    
    private lazy var useDateTitleLabel: UILabel = {
        $0.configureImageLabel(titleImage: .hourglass, text: "소비기한: \(useDateCache)일 이내")
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return $0
    }(UILabel())
    
    private lazy var useDateSwitch: CustomSwitch = {
        $0.delegate = self
        return $0
    }(CustomSwitch())
    
    // 소비기한(날짜 버튼, 피커 뷰)
    private let useDateOutsideStack: UIStackView = {
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    // 소비기한(날짜버튼들)
    private let useDateBottomHStack: UIStackView = {
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    private let useDateSetOneDay = UseDateLabel(useDate: .oneDay)
    private let useDateSetThreeDay = UseDateLabel(useDate: .threeDay)
    private let useDateSetOneWeek = UseDateLabel(useDate: .oneWeek)
    private let useDateSetTwoWeek = UseDateLabel(useDate: .twoWeek)
    private let useDateSetDirectSetting = UseDateLabel(useDate: .directSetting)
    private let spacerView = UIView()
    
    private lazy var usedateLabels = [useDateSetOneDay, useDateSetThreeDay, useDateSetOneWeek, useDateSetTwoWeek, useDateSetDirectSetting]
    
    private lazy var pickerView: UIPickerView = {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.disappear(isAlpha: false)
        
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UIPickerView())
    
    private lazy var categoryHStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentHalfModal))
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(UIStackView())
    
    private let categoryLabel: UILabel = {
        $0.configureImageLabel(titleImage: .folder, text: "식품 분류: 기타")
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return $0
    }(UILabel())
    
    private let chevronRightView: UIImageView = {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .systemGray2
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    // MARK: - Attribute
    @available(*, unavailable)
    override func attribute() {
        super.attribute()
        
        collectionView.register(IngredientCell.self, forCellWithReuseIdentifier: IngredientCell.identifier)
        
        configureNavigation()
        configureUseDateLabel()
    }
    
    private func configureNavigation() {
        navigationItem.title = "재료 등록하기"
        
        rightBarButtonItem(systemName: "checkmark", #selector(dismissViewController), .systemGray2)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func configureUseDateLabel() {
        usedateLabels.forEach { label in
            label.delegate = self
        }
        
        usedateLabels[0].isSelected = true
    }
    
    // MARK: - Layout
    @available(*, unavailable)
    override func addSubviews() {
        view.addSubview(imageSelectionLabel)
        view.addSubview(collectionView)
        
        view.addSubview(containerView)
        containerView.addSubview(ingredientNameTextField)

        useDateOutsideStack.addArrangedSubview(useDateTopHStack)
        useDateTopHStack.addArrangedSubview(useDateTitleLabel)
        useDateTopHStack.addArrangedSubview(useDateSwitch)
        
        containerView.addSubview(useDateOutsideStack)
        
        useDateOutsideStack.addArrangedSubview(useDateBottomHStack)
        useDateBottomHStack.addArrangedSubview(useDateSetOneDay)
        useDateBottomHStack.addArrangedSubview(useDateSetThreeDay)
        useDateBottomHStack.addArrangedSubview(useDateSetOneWeek)
        useDateBottomHStack.addArrangedSubview(useDateSetTwoWeek)
        useDateBottomHStack.addArrangedSubview(useDateSetDirectSetting)
        useDateBottomHStack.addArrangedSubview(spacerView)
        
        useDateOutsideStack.addArrangedSubview(pickerView)
        
        containerView.addSubview(categoryHStackView)
        categoryHStackView.addArrangedSubview(categoryLabel)
        categoryHStackView.addArrangedSubview(chevronRightView)
    }
    
    @available(*, unavailable)
    override func layout() {
        imageSelectionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(20)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(imageSelectionLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(200)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalToSuperview()
        }
        
        ingredientNameTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        useDateOutsideStack.snp.makeConstraints {
            $0.top.equalTo(ingredientNameTextField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        useDateTopHStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        useDateSwitch.snp.makeConstraints {
            $0.width.equalTo(40)
        }
        
        usedateLabels.forEach { label in
            label.snp.makeConstraints {
                $0.width.equalTo(label.intrinsicContentSize.width+30)
                $0.height.equalTo(label.intrinsicContentSize.height+10)
            }
        }
        
        useDateBottomHStack.spacing = 10
        
        pickerView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        useDateOutsideStack.spacing = 12
        
        categoryHStackView.snp.makeConstraints {
            $0.top.equalTo(useDateOutsideStack.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}


// MARK: - UseDateLabelDelegate
extension IngredientRegistViewController: UseDateLabelDelegate {
    func selectedLabel(_ label: UseDateLabel) {
        usedateLabels.forEach {
            if $0.text == label.text { // 선택한 탭 설정
                $0.isSelected = true
                
                if label.text == "직접 설정" { // 선택한 탭이 `직접 설정` 일 때
                    tappedDirectSettingLabel()
                } else { // 선택한 탭이 `직접 설정`이 아닐 때\
                    pickerView.alpha = 0
                    
                    tappedUsedateLabel(label)
                    whenPickerViewIsShowing()
                }
                
                registeringItem.changeUseDate(useDateCache)
            } else { // 선택하지 않은 탭 설정
                $0.isSelected = false
            }
        }
    }
    
    private func tappedDirectSettingLabel() {
        UIView.animate(withDuration: 0.3) {
            self.pickerView.appear(isAlpha: true)
        } completion: { finished in
            self.setupUseDateText(index: self.sectionRow,
                                  label: self.useDateTitleLabel) // pickerView의 데이터를 Label에 반영
        }
    }
    
    private func tappedUsedateLabel(_ label: UseDateLabel) {
        useDateCache = Int(label.text?.dropLast() ?? "") ?? 0 // 텍스트 임시 저장.
        useDateTitleLabel.configureImageLabel(
            titleImage: .hourglass,
            text: "소비기한: \(label.text ?? "0일") 이내"
        )  // 탭의 데이터를 Label에 반영
    }
    
    private func whenPickerViewIsShowing() {
        if !pickerView.isHidden {
            UIView.animate(withDuration: 0.3) {
                self.pickerView.isHidden = true
            }
        }
    }
}


// MARK: - ConfigureViewController
extension IngredientRegistViewController {
    private func editingAdditionButtonStatus() {
        guard let text = ingredientNameTextField.text else { return }
        
        // 이미지를 선택하지 않았거나, 재료명을 미입력, 이미 존재하는 재료명이면 비활성화
        if text.isEmpty || registeringItem.fetchImage() == nil || ingredientNames.contains(text) {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = .systemGray2
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
        
        registeringItem.changeName(text)
    }
    
    func configureIngredientNames(_ name: String, _ ingredientNames: [String]) {
        self.ingredientNameTextField.text = name 
        self.ingredientNames = ingredientNames // 이미 존재하는 재료명인지 확인을 위한 property
    }
}


// MARK: - 화면전환 메서드
extension IngredientRegistViewController {
    @objc private func dismissViewController(_ action: UIAction) {
        pressedAdditionButton()
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func presentHalfModal() {
        let vc = CategorySelectViewController()
        guard let category = categoryLabel.text?.components(separatedBy: ": ")[1] else { return }
        
        vc.currentCategory(category)
        
        vc.closure = { category in
            self.categoryLabel.configureImageLabel(
                titleImage: .folder,
                text: "식품 분류: \(category)"
            )
        }
        
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .pageSheet
        
        if let sheet = navi.sheetPresentationController {
            sheet.detents = [.medium()]     // custom은 iOS 16이상부터 가능. 아직 커스텀 적용할 필요성은 없으니 미적용.
            sheet.prefersGrabberVisible = true
        }
        
        present(navi, animated: true)
    }
    
    private func pressedAdditionButton() {
        let name = registeringItem.fetchName()
        guard let category = categoryLabel.text?.split(separator: " ").last else {return assertionFailure("카테고리가 선택되지 않았습니다.")}
        registeringItem.changeCategory(String(category))
        
        coredataManager.registIngredient(registeringItem)
        
        let ingredientSearchItem = IngredientSearchItem(name: name, category: String(category))
        completion(ingredientSearchItem)
    }
}

// MARK: - CustomSwitchDelegate
extension IngredientRegistViewController: CustomSwitchDelegate {
    func sendStatus(_ isOn: Bool) {
        switch isOn {
        case true:
            self.useDateTitleLabel.configureImageLabel(
                titleImage: .hourglass,
                text: "소비기한: \(self.useDateCache)일 이내"
            )
            registeringItem.changeUseDate(0)
            
            UIView.animate(withDuration: 0.3) {
                self.useDateBottomHStack.appear(isAlpha: true)
                self.pickerView.appear(isAlpha: true)
            }
        case false:
            self.useDateBottomHStack.alpha = 0
            self.pickerView.alpha = 0
            self.useDateTitleLabel.configureImageLabel(
                titleImage: .hourglass,
                text: "소비기한: 기타"
            )
            UIView.animate(withDuration: 0.3) {
                self.useDateBottomHStack.disappear(isAlpha: false)
                self.pickerView.disappear(isAlpha: false)
            }
        }
    }
}



// MARK: - UIPicker
extension IngredientRegistViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return time[row].rawValue
        case 1:
            return "\(time[sectionRow].list[row])\(time[sectionRow].suffixString)"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: // 왼쪽(Section)
            sectionRow = row                 // 섹션 변경 반영
            pickerView.reloadAllComponents() // 섹션 변경 시, 아이템 목록이 변경되도록 리로드
            
            list = time[sectionRow].list                                       // 섹션 변경 시, 리스트 적용
            itemRow = (itemRow >= list.endIndex) ? (list.endIndex-1) : itemRow // 섹션의 아이템이 많은 곳 -> 적은 곳 이동 시
        default: // 오른쪽(Item)
            list = time[sectionRow].list                                       // 없으면, 실제 목록이 없는 상태이므로 아이템 변경시에도 리스트 적용
            itemRow = row
        }
        
        setupUseDateText(index: sectionRow, label: useDateTitleLabel)
    }
    
    private func setupUseDateText(index: Int, label: UILabel) {
        switch time[index] {
        case .day:
            label.configureImageLabel(
                titleImage: .hourglass,
                text: "소비기한: \(list[itemRow])일 이내"
            )
            useDateCache = list[itemRow]
        case .month:
            label.configureImageLabel(
                titleImage: .hourglass,
                text: "소비기한: \(list[itemRow] * 30)일 이내"
            )
            useDateCache = list[itemRow] * 30
        case .year:
            label.configureImageLabel(
                titleImage: .hourglass,
                text: "소비기한: \(list[itemRow] * 30 * 12)일 이내"
            )
            useDateCache = list[itemRow] * 30 * 12
        }
    }
}

extension IngredientRegistViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return time.count
        case 1:
            return time[sectionRow].list.count
        default:
            return 0
        }
    }
}


// MARK: - UITextFieldDelegate
extension IngredientRegistViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // TODO: 한글은 최대 6자, 영어 등 외국어는 따로 처리 필요.
        // Question: TextField 또는 전체글자의 width로 판단할 수는 없을까?
        let max = 10
        guard let text = textField.text else { return true }
        let current = text.count + string.count - range.length
        
        return current <= max
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension IngredientRegistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 5
        let spacing: CGFloat = 12
        let safeArea: CGFloat = 16
        let size = (collectionView.bounds.width - 2*safeArea - (columns-1)*spacing) / columns
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init()) // 이미지 선택 시 isSelected = true
        
        let ingredient = IngredientRegistData.allCases[indexPath.row]
        
        registeringItem.changeImage(ingredient.image)
        categoryLabel.configureImageLabel(
            titleImage: .folder,
            text: "식품 분류: \(IngredientRegistData.allCases[indexPath.row].category)"
        )
        editingAdditionButtonStatus()
        // override isSelected는 일반적으로 직접 조작하지 않고, 이와같이 간접적으로 다루는 것을 권장한다.
        // 단순하게 indexPath의 cell에 대한 설정을 부여할 경우, didSelectItemAt만으로는 Cell의 isSelected를 인지하지 못하므로, isSelected를 조작하는 메서드를 사용해줘야 함.
        // cell에 대한 직접적인 조작은 cell에서 하자. 코드 가독성에서도 유용하다.
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)  // 다른 이미지 선택 시 isSelected = false
    }
}

// MARK: - UICollectionViewDataSource
extension IngredientRegistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IngredientRegistData.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCell.identifier, for: indexPath) as! IngredientCell
        
        cell.configureCell(image: IngredientRegistData.allCases[indexPath.row].image,
                           pageType: .regist)
        
        return cell
    }
}

// MARK: - Keyboardable
extension IngredientRegistViewController: Keyboardable {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
}
