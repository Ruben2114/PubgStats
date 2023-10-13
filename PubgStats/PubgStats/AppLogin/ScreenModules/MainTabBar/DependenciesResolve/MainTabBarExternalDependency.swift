//
//  MainTabBarExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol MainTabBarExternalDependency {
    func mainTabBarCoordinator(player: String, id: String) -> Coordinator
    func profileCoordinator() -> BindableCoordinator
    func favouriteCoordinator() -> Coordinator
    func guideCoordinator() -> Coordinator
    func settingsCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func guideNavigationController() -> UINavigationController
    func settingsNavigationController() -> UINavigationController
    func tabBarController() -> UITabBarController
    
}

extension MainTabBarExternalDependency {
    func mainTabBarCoordinator(player: String, id: String) -> Coordinator {
        MainTabBarCoordinatorImp(dependencies: self, player: player, id: id)
    }
}
