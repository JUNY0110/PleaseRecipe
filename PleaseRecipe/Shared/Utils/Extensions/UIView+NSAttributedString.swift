//
//  UIView+NSAttributedString.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/27/24.
//

import UIKit


extension UILabel {
    func configureImageLabel(titleImage: LabelTitle, text: String) {
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: titleImage.systemName)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(NSAttributedString(string: text))
        
        self.attributedText = attributedString
//        return attributedString
    }
}


enum LabelTitle: String {
    case hourglass
    case folder
    
    
    var systemName: String {
        return self.rawValue
    }
}
