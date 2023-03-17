//
//  TabCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//
import UIKit

final class TabCoordinator: Coordinator, CreateNavController{
    var navigation: UINavigationController
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
        
        let coordinator = itemTab.makeProfileCoordinator(navigation: navigation)
        coordinator.start()
        append(child: coordinator)
        /*
         let coordinator2 = tabFactory.makeProfileCoordinator(navigation: navigation)
         coordinator2.start()
         append(child: coordinator2)
         
         let coordinator3 = tabFactory.makeProfileCoordinator(navigation: navigation)
         coordinator3.start()
         append(child: coordinator3)
         
         */
        let viewsTotal = itemTab.allView(coordinator: coordinator)
        tabBarController.viewControllers = viewsTotal
        tabBarController.tabBar.backgroundColor = .white
    }
    private func configWindow(window: UIWindow?) {
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
