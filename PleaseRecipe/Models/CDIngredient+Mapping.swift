//
//  CDIngredient+Mapping.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/22/24.
//


import UIKit

extension CDIngredient {
    func toDomain() -> MaterialItem {
        return .init(
            image: UIImage(data: image),
            name: name,
            useDate: useDate,
            category: category?.title ?? "",
            isSelected: false
        )
    }
}
