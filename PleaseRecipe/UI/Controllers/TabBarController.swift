//
//  TabBarController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 2023/10/10.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let foodListViewModel = FoodListViewModel()
    
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
        let vc1 = UINavigationController(rootViewController: UIViewController())
        let vc2 = UINavigationController(rootViewController: FoodListViewController(viewModel: foodListViewModel))
        let vc3 = UINavigationController(rootViewController: UIViewController())
        
        vc1.title = "냉장고"
        vc2.title = "레시피"
        vc3.title = "장바구니"
        
        setViewControllers([vc1, vc2, vc3], animated: false)
        modalPresentationStyle = .fullScreen
        tabBar.backgroundColor = .white
    }
    
    private func setupItemImage() {
        guard let items = tabBar.items else { return }
        items[0].image = UIImage(systemName: "refrigerator")
        items[1].image = UIImage(systemName: "frying.pan")
        items[2].image = UIImage(systemName: "cart")
    }
    
    private func setTabBarItemColor(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.selected.iconColor = Color.mainColor
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.mainColor]
    }
}
