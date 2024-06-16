//
//  TabBarController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 2023/10/10.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        setupTabBar()
        setupItemImage()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        setTabBarItemColor(appearance.stackedLayoutAppearance)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTabBar() {
        let vc1 = UINavigationController(rootViewController: MaterialStorageViewController())
        let vc2 = UINavigationController(rootViewController: UIViewController())
        let vc3 = UINavigationController(rootViewController: UIViewController())
        
        vc1.title = "재료창고"
        vc2.title = "레시피"
        vc3.title = "설정"
        
        setViewControllers([vc1, vc2, vc3], animated: false)
        modalPresentationStyle = .fullScreen
        tabBar.backgroundColor = .white
    }
    
    private func setupItemImage() {
        guard let items = tabBar.items else { return }
        let imageNames = ["refrigerator", "recipe", "cart"]
        
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            items[i].image = UIImage(resource: ImageResource(name: imageName, bundle: .main)).resize(newWidth: 22)
        }
    }
    
    private func setTabBarItemColor(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.selected.iconColor = .mainRed
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainRed]
    }
}
