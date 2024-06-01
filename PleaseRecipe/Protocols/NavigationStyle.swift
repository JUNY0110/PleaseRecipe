//
//  NavigationStyle.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/30/24.
//

import UIKit

typealias NavigationStyle = NavigationRightBarStyle & NavigationLeftBarStyle

protocol NavigationRightBarStyle: AnyObject {
    func rightBarButtonItem(systemName: String, _ selector: Selector?, _ color: UIColor)
    func rightBarButtonItem(resourceImage: ImageResource, _ selector: Selector?, _ color: UIColor)
    func rightBarButtonItem(imageName: String, _ selector: Selector?, _ color: UIColor)
}

protocol NavigationLeftBarStyle: AnyObject {
    func leftBarButtonItem(systemName: String, _ selector: Selector?, _ color: UIColor)
    func leftBarButtonItem(resourceImage: ImageResource, _ selector: Selector?, _ color: UIColor)
    func leftBarButtonItem(imageName: String, _ selector: Selector?, _ color: UIColor)
}

// MARK: - Navigation RightBar
extension NavigationRightBarStyle where Self: UIViewController {
    func rightBarButtonItem(systemName: String, _ selector: Selector?, _ color: UIColor = .black) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: systemName),
                                                            style: .plain,
                                                            target: self, action: selector)
        navigationItem.rightBarButtonItem?.tintColor = color
    }
    func rightBarButtonItem(resourceImage: ImageResource, _ selector: Selector?, _ color: UIColor = .black) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(resource: resourceImage),
                                                            style: .plain,
                                                            target: self, action: selector)
        navigationItem.rightBarButtonItem?.tintColor = color
    }
    func rightBarButtonItem(imageName: String, _ selector: Selector?, _ color: UIColor = .black) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName),
                                                            style: .plain,
                                                            target: self, action: selector)
        navigationItem.rightBarButtonItem?.tintColor = color
    }
}

// MARK: - Navigation LeftBar
extension NavigationLeftBarStyle where Self: UIViewController {
    func leftBarButtonItem(systemName: String, _ selector: Selector?, _ color: UIColor = .black) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: systemName),
                                                            style: .plain,
                                                            target: self, action: selector)
        navigationItem.leftBarButtonItem?.tintColor = color
    }
    func leftBarButtonItem(resourceImage: ImageResource, _ selector: Selector?, _ color: UIColor = .black) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: resourceImage),
                                                            style: .plain,
                                                            target: self, action: selector)
        navigationItem.leftBarButtonItem?.tintColor = color
    }
    func leftBarButtonItem(imageName: String, _ selector: Selector?, _ color: UIColor = .black) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName),
                                                            style: .plain,
                                                            target: self, action: selector)
        navigationItem.leftBarButtonItem?.tintColor = color
    }
}
