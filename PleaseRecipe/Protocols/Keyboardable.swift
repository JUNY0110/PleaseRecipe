//
//  Keyboardable.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/30/24.
//

import UIKit

protocol Keyboardable: AnyObject {
    func hideKeyboard()
}


extension Keyboardable where Self: UIViewController {
    func hideKeyboard() {
        view.endEditing(true)
    }
}

