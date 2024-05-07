//
//  MainTabBarController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 29/4/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    private let viewModel: MainTabBarViewModel

    init(dependencies: MainTabBarDependencies) {
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .black
        self.tabBar.tintColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        self.tabBar.unselectedItemTintColor = .systemGray
        self.showLoading()
    }
    
    func setViewControllers(_ tabBarView: [UINavigationController]) {
        self.viewControllers = tabBarView
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        viewModel.tabBarSelect(item.title ?? "")
    }
}

extension MainTabBarController: LoadingPresentationDisplayable { }
