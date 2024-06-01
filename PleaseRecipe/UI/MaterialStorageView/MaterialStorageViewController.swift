//
//  MaterialStorageViewController.swift
//  PleaseRecipe
//
//  Created by 지준용 on 5/29/24.
//

import UIKit

import SnapKit

final class MaterialStorageViewController: BaseViewController {
    
    // MARK: - Properties
    private let items = ["냉장", "냉동", "상온"]
    private var viewControllers: [UIViewController] {
        [self.냉장보관재료, self.냉동보관재료, self.상온보관재료]
    }
    
    private var currentPage = 0 {
        didSet {
            self.segmentedControl.selectedSegmentIndex(currentPage)
            
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            
            self.pageViewController.setViewControllers([viewControllers[self.currentPage]],
                                                       direction: direction,
                                                       animated: true)
        }
    }
    
    // MARK: - Views
    private lazy var segmentedControl: CustomSegmentedControl = {
        $0.addTarget(self, action: #selector(changePage), for: .valueChanged)
        return $0
    }(CustomSegmentedControl(items: items))
    
    private lazy var pageViewController: UIPageViewController = {
        $0.setViewControllers([viewControllers[0]], direction: .forward, animated: true)
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal))
    
    private let containerView = UIView()
    private let 냉장보관재료 = MaterialViewController()
    private let 냉동보관재료 = MaterialViewController()
    private let 상온보관재료 = MaterialViewController()
    
    // MARK: - Attribute
    override func attribute() {
        super.attribute()
        
        configureNavigation()
    }
    
    // MARK: - Layout
    override func addSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
        containerView.addSubview(pageViewController.view)
    }
    
    override func layout() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(230)
            $0.height.equalTo(24)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(24)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Navigation
extension MaterialStorageViewController: Navigationable {
    private func configureNavigation() {
        rightBarButtonItem(systemName: "plus", #selector(presentViewController))
    }
    
    @objc func presentViewController() {
        let vc = MaterialRegistViewController()
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
}

// MARK: - SegmentedControl를 이용해 PageController를 조작하기 위한 코드
extension MaterialStorageViewController {
    @objc func changePage(_ control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
}


// MARK: - PageViewController을 활용한 동작을 적용하는 코드
extension MaterialStorageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool)
    {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = self.viewControllers.firstIndex(of: viewController) else { return }
        
        self.currentPage = index
    }
}

extension MaterialStorageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController?
    {
        guard let index = self.viewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else { return nil }  // 현재 VC가 첫번째 VC이면, 왼쪽으로 넘기지 못하고
        
        return self.viewControllers[index - 1] // 그렇지 않으면, 왼쪽으로 넘긴다.
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController?
    {
        guard let index = self.viewControllers.firstIndex(of: viewController),
              index + 1 < self.viewControllers.count
        else { return nil }  // 현재 VC가 마지막 VC이면, 오른쪽으로 넘기지 못하고
        
        return self.viewControllers[index + 1]  // 그렇지 않으면, 오른쪽으로 넘긴다.
    }
}
