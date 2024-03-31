//
//  FoodListViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 2023/10/08.
//

import UIKit

import SnapKit

final class FoodListViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: FoodListViewModel
    
    // MARK: - Views
    
    private let searchController = UISearchController()
    private lazy var foodListView: UITableView = {
        $0.backgroundColor = .systemBackground
        $0.register(FoodListCell.self, forCellReuseIdentifier: FoodListCell.identifier)
        $0.delegate = self
        $0.prefetchDataSource = self
        return $0
    }(UITableView())
    
    // MARK: - Init
    
    init(viewModel: FoodListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = foodListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureNavigationBarItems()
        configureSearchBar()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBarColor()
    }
    
    // MARK: - Methods
    
    private func moveToRecipeViewController(_ data: Food) {
        let recipeViewController = RecipeViewController()
        recipeViewController.foodData = data
        
        guard let width = screenWidth else { return }
        recipeViewController.viewModel = .init(width: width)
        
        self.navigationController?.pushViewController(recipeViewController, animated: true)
    }
}

// MARK: - NavigationUI

extension FoodListViewController {
    private func configureNavigationBarItems() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationItem.title = "요리 레시피"
    }
    
    private func configureNavigationBarColor() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    private func configureSearchBar() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.automaticallyShowsCancelButton = false
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
}

// MARK: - SetupDiffableDataSource

extension FoodListViewController {
    private func setupDataSource() {
        foodListView.dataSource = viewModel.setupDataSource(foodListView)
    }
}

// MARK: - UISearchResultsUpdating

extension FoodListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.applySnapshot(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, 
                 !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        viewModel.applySnapshot(with: text)
        dismissKeyboard()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.applySnapshot()
        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate

extension FoodListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let itemIdentifier = viewModel.diffableDataSource.itemIdentifier(for: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            moveToRecipeViewController(itemIdentifier)
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension FoodListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            reconfigureCell(of: indexPath)
        }
    }
    
    private func reconfigureCell(of indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let itemIdentifier = self.viewModel.diffableDataSource.itemIdentifier(for: indexPath) else { return }
            self.viewModel.snapshot.reconfigureItems([itemIdentifier])
        }
    }
}
