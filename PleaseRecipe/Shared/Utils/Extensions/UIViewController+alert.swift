//
//  UIViewController+alert.swift
//  PleaseRecipe
//
//  Created by 지준용 on 7/12/24.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String?,
        message: String?,
        yesHandler: ((UIAlertAction) -> Void)? = nil,
        noHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: "예", style: .default, handler: yesHandler)
        let no = UIAlertAction(title: "아니오", style: .destructive, handler: noHandler)
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true)
    }
}
