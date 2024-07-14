//
//  UIView+appear.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/27/24.
//

import UIKit


extension UIView {
    /// 주로 StaciView 내부의 View로, Animate 함수와 함께 사용하기 위한 메서드
    func disappear(isAlpha: Bool) {
        if isAlpha {
            self.alpha = 0     // 자연스럽게 숨기는 시각효과를 위한 설정
        }
        self.isHidden = true   // 숨기는 동작
    }
    
    /// 주로 StaciView 내부의 View로, Animate 함수와 함께 사용하기 위한 메서드
    func appear(isAlpha: Bool) {
        if isAlpha {
            self.alpha = 1        // 자연스럽게 나타나는 시각효과를 위한 설정
        }
        self.isHidden = false     // 나타나는 동작
    }
}
