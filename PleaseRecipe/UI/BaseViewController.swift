//
//  BaseViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/29/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        addSubviews()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(true)
        
        layout()
    }
    
    // MARK: - Attribute
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Layout
    func addSubviews() {}
    func layout() {}
}
