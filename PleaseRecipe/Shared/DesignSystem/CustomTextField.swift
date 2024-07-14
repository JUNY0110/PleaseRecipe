//
//  CustomTextField.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/31/24.
//

import UIKit

final class CustomTextField: UITextField {
    
    // 붙여놓기 금지 설정
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
