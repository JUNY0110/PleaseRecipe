//
//  MaterialRegistViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/30/24.
//

import UIKit

import SnapKit


final class MaterialRegistViewController: BaseViewController {
    
    // MARK: - Properties
    private let time = TimeSection.allCases
    private var sectionRow = 0
    private var itemRow = 0
    private var material: Material = .init(image: nil,
                                           name: "",
                                           registDate: nil,
                                           useDate: Int.max,
                                           category: .식재료)
    
    // MARK: - Views
    private let imageSelectionLabel: UILabel = {
        $0.text = "이미지 선택"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return $0
    }(UILabel())
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        $0.collectionViewLayout = flowLayout
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    private let userInputView = UIView()
    
    private let materialNameLabel: UILabel = {
        $0.text = "재료명"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return $0
    }(UILabel())
    
    private lazy var materialNameTextField: UITextField = {
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
    
    private let useDateLabel: UILabel = {
        $0.text = "소비기한"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return $0
    }(UILabel())
    
    private lazy var pickerView: UIPickerView = {
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UIPickerView())
    
    private lazy var useDateTextField: CustomTextField = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.backgroundColor = .secondarySystemFill
        $0.placeholder = "선택하지 않으면 '무기한'으로 분류"
        $0.borderStyle = .roundedRect
        $0.autocorrectionType = .no
        $0.inputView = pickerView
        
        $0.leftView = UIView()
        $0.leftViewMode = .always
        return $0
    }(CustomTextField())
    
    private let categoryLabel: UILabel = {
        $0.text = "식품 분류"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return $0
    }(UILabel())
    
    private lazy var categoryToggleLabel: UILabel = {
        $0.text = "  식재료"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .secondarySystemFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleCategory))
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UILabel())
    
    private lazy var cancelButton: UIButton = {
        $0.configuration?.attributedTitle = .configureTitle(.cancel, size: 16, weight: .semibold)
        $0.configuration?.baseForegroundColor = .gray
        $0.addAction(UIAction { [unowned self] action in self.dismissViewController(action) },
                     for: .touchUpInside)
        return $0
    }(UIButton(configuration: .gray()))
    
    private lazy var additionButton: UIButton = {
        $0.configuration?.attributedTitle = .configureTitle(.addition, size: 16, weight: .semibold)
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.background.backgroundColor = .secondarySystemFill
        $0.isEnabled = false
        $0.addAction(UIAction { [unowned self] action in self.dismissViewController(action) },
                     for: .touchUpInside)
        return $0
    }(UIButton(configuration: .filled()))
    
    // MARK: - Attribute
    override func attribute() {
        super.attribute()
        
        collectionView.register(MaterialCell.self, forCellWithReuseIdentifier: MaterialCell.identifier)
        
        configureNavigation()
        configurePickerToolBar()
    }
    
    private func configureNavigation() {
        navigationItem.title = "재료 등록하기"
    }
    
    // MARK: - Layout
    @available(*, unavailable)
    override func addSubviews() {
        view.addSubview(imageSelectionLabel)
        view.addSubview(collectionView)
        view.addSubview(userInputView)
        userInputView.addSubview(materialNameLabel)
        userInputView.addSubview(materialNameTextField)
        userInputView.addSubview(useDateLabel)
        userInputView.addSubview(useDateTextField)
        userInputView.addSubview(categoryLabel)
        userInputView.addSubview(categoryToggleLabel)
        view.addSubview(cancelButton)
        view.addSubview(additionButton)
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
        
        userInputView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalToSuperview()
        }
        
        materialNameLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        materialNameTextField.snp.makeConstraints {
            $0.top.equalTo(materialNameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        useDateLabel.snp.makeConstraints {
            $0.top.equalTo(materialNameTextField.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        useDateTextField.snp.makeConstraints {
            $0.top.equalTo(useDateLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(useDateTextField.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        categoryToggleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-8)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        
        additionButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-8)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(10)
            $0.height.equalTo(50)
        }
    }
}

// MARK: - ConfigureViewController
extension MaterialRegistViewController {
    @objc func toggleCategory() {
        if categoryToggleLabel.text == "  식재료" {
            categoryToggleLabel.text = "  조미료"
        } else {
            categoryToggleLabel.text = "  식재료"
        }
    }
    
    private func editingAdditionButtonStatus() {
        guard let text = materialNameTextField.text else { return }
        
        if text.isEmpty || material.image == nil { // 이미지를 선택하지 않았거나, 재료명을 입력하지 않으면 비활성화
            additionButton.isEnabled = false
            additionButton.configuration?.background.backgroundColor = .secondarySystemFill
        } else {
            additionButton.isEnabled = true
            additionButton.configuration?.background.backgroundColor = .mainRed
        }
    }
    
    func configureMaterialName(_ name: String?) {
        materialNameTextField.text = name
    }
}


// MARK: - 화면전환 메서드
extension MaterialRegistViewController {
    private func dismissViewController(_ action: UIAction) {
        let sender = action.sender as! UIButton
        guard let title = sender.titleLabel?.text,
              let buttonType = ButtonType(rawValue: title) else { return }
        
        switch buttonType {
        case .addition:
            pressedAdditionButton()
        case .cancel:
            pressedCancelButton()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func pressedCancelButton() {
        print("취소")
    }
    
    private func pressedAdditionButton() {
        guard let name = materialNameTextField.text else { return }
        guard let useDateText = useDateTextField.text else { return  }
        guard let categoryText = categoryToggleLabel.text else { return  }
        guard let category = MaterialCategory(rawValue: categoryText) else { return }
        
        material.name = name
        
        if useDateText.isEmpty {
            material.useDate = Int.max // 무기한
        } else {
            guard let useDate = Int(useDateText.components(separatedBy: "-")[1]) else { return }
            material.useDate = useDate // 소비기한 있음
        }
        
        material.category = category
    }
}

// MARK: - PickerToolBar
extension MaterialRegistViewController {
    private func configurePickerToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .darkText
        toolBar.backgroundColor = .darkGray
        toolBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 35) // width를 명확하게 잡아주지 않으면 레이아웃 에러 알림 발생
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tappedDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tappedCancelButton))
        
        toolBar.setItems([cancelButton, space, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        useDateTextField.inputAccessoryView = toolBar
    }
    
    @objc func tappedDoneButton() {
        useDateTextField.resignFirstResponder()
    }
    
    @objc func tappedCancelButton() {
        useDateTextField.resignFirstResponder()
    }
}


// MARK: - UIPicker
extension MaterialRegistViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return time[row].rawValue
        case 1:
            if time[sectionRow] == .none {
                return "무기한"
            }
            return "\(time[sectionRow].list[row])\(time[sectionRow].rawValue)"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var list: [Int]!
        
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
        
        switch time[sectionRow] {
        case .none:
            useDateTextField.text = ""
        case .day:
            useDateTextField.text = "D-\(list[itemRow])"
        case .month:
            useDateTextField.text = "D-\(list[itemRow] * 30)"
        case .year:
            useDateTextField.text = "D-\(list[itemRow] * 365)"
        }
    }
}

extension MaterialRegistViewController: UIPickerViewDataSource {
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
extension MaterialRegistViewController: UITextFieldDelegate {
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
extension MaterialRegistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 5
        let spacing: CGFloat = 12
        let safeArea: CGFloat = 16
        let size = (collectionView.bounds.width - 2*safeArea - (columns-1)*spacing) / columns
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MaterialCell.identifier, for: indexPath) as! MaterialCell
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init()) // 이미지 선택 시 isSelected = true
        material.image = cell.image
        
        editingAdditionButtonStatus()
        // override isSelected는 일반적으로 직접 조작하지 않고, 이와같이 간접적으로 다룰 수 있다.
        // 단순하게 indexPath의 cell에 대한 설정을 부여할 경우, didSelectItemAt만으로는 Cell의 isSelected를 인지하지 못하므로, isSelected를 조작하는 메서드를 사용해줘야 함.
        // cell에 대한 직접적인 조작은 cell에서 하자. 코드 가독성에서도 유용하다.
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)                        // 다른 이미지 선택 시 isSelected = false
    }
}

// MARK: - UICollectionViewDataSource
extension MaterialRegistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MaterialLiteral.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MaterialCell.identifier, for: indexPath) as! MaterialCell
        
        cell.configureCell(image: MaterialLiteral.allCases[indexPath.row].image,
                           pageType: .regist)
        
        return cell
    }
}

// MARK: - Keyboardable
extension MaterialRegistViewController: Keyboardable {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
}
