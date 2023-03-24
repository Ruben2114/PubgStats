//
//  MainTabBarExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol MainTabBarExternalDependency {
    func mainTabBarCoordinator() -> Coordinator
    func profileCoordinator() -> Coordinator
    func favouriteCoordinator() -> Coordinator
    func rankingCoordinator() -> Coordinator
    func guideCoordinator() -> Coordinator
    func contactCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func rankingNavigationController() -> UINavigationController
    func guideNavigationController() -> UINavigationController
    func contactNavigationController() -> UINavigationController
    func tabBarController() -> UITabBarController
    
}

extension MainTabBarExternalDependency {
    func mainTabBarCoordinator() -> Coordinator {
        MainTabBarCoordinatorImp(dependencies: self)
    }
}
