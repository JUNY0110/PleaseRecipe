//
//  CustomSearchBar.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/2/24.
//

import UIKit

import Lottie
import SnapKit


final class CustomSearchBar: UISearchBar {
    
    // MARK: - Views
    private let leftContainerView = UIView()
    
    private lazy var animationView: LottieAnimationView = {
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedLeftView))
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(LottieAnimationView(name: "search"))
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        
        addSubviews()
        setupLeftView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Attribute
    private func attribute() {
        configureSearchBar()
        configureSearchTextField()
    }
    
    // MARK: - Layout
    private func addSubviews() {
        addSubview(leftContainerView)
        leftContainerView.addSubview(animationView)
    }
    
    private func setupLeftView() {
        guard let leftView = searchTextField.leftView else { return }
        leftContainerView.frame = leftView.frame
        animationView.frame = leftView.frame
        
        searchTextField.leftView = leftContainerView
        searchTextField.leftView?.tintColor = .black
    }
}

// MARK: - Methods
extension CustomSearchBar {
    private func configureSearchBar() {
        placeholder = "식재료를 검색하세요"
        autocorrectionType = .no
        spellCheckingType = .no
        returnKeyType = .search
        enablesReturnKeyAutomatically = true
    }
    
    private func configureSearchTextField() {
        searchTextField.delegate = self
        
        searchTextField.layer.borderColor = UIColor.mainRed.cgColor
        searchTextField.layer.borderWidth = 2
        searchTextField.layer.cornerRadius = 4
        
        searchTextField.backgroundColor = .systemBackground
        searchTextField.tintColor = .mainRed
    }
    
    @objc private func tappedLeftView() {
        animationView.play(fromProgress: 0, toProgress: 0.5)
        
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        } else {
            searchTextField.becomeFirstResponder()
        }
    }
}


// MARK: - UITextFieldDelegate
extension CustomSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        
        return true
    }
}
