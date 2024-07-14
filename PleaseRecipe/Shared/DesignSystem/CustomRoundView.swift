//
//  CustomRoundView.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/25/24.
//

import UIKit


final class CustomRoundView: UIView, Roundable {
    override func layoutSubviews() {
        super.layoutSubviews()
        makeRoundRadius(radius: frame.height / 2)
    }
}


class CustomRoundLabel: UILabel, Roundable {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        makeRoundRadius(radius: frame.height / 2)
    }
}
