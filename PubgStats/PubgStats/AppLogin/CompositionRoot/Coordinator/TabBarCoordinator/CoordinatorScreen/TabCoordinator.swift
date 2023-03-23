//
//  TabCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//
import UIKit

final class TabCoordinator: Coordinator{
    var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let itemTab: TabBarFactory
    private let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController,navigation: UINavigationController, itemTab: TabBarFactory, window: UIWindow?){
        self.tabBarController = tabBarController
        self.navigation = navigation
        self.itemTab = itemTab
        configWindow(window: window)
    }
    func start() {
        
        let coordinator = itemTab.makeProfileCoordinator(navigation: navigation!)
        coordinator.start()
        append(child: coordinator)
        
        let viewsTotal = itemTab.allView()
        tabBarController.viewControllers = viewsTotal
        tabBarController.tabBar.backgroundColor = .white
    }
    private func configWindow(window: UIWindow?) {
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
