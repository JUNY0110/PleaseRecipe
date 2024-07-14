//
//  Roundable.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/26/24.
//

import UIKit


protocol Roundable: AnyObject {}

extension Roundable where Self: UIView {
    func makeRoundRadius(radius: CGFloat) {
        layer.cornerRadius = radius
    }
}
