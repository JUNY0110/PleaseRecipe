//
//  MaterialProtocol.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/21/24.
//

import UIKit


protocol IngredientProtocol: CaseIterable, Hashable {
    var name: String { get }
    var image: UIImage { get }
}
