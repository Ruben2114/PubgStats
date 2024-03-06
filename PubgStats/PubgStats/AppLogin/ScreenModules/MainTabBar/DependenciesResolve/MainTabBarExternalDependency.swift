//
//  MainTabBarExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol MainTabBarExternalDependency {
    func mainTabBarCoordinator(data: IdAccountDataProfileRepresentable?) -> Coordinator
    func profileCoordinator(navigation: UINavigationController?) -> BindableCoordinator
    func favouriteCoordinator(navigation: UINavigationController?) -> Coordinator
    func guideCoordinator() -> Coordinator
    func settingsCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func guideNavigationController() -> UINavigationController
    func settingsNavigationController() -> UINavigationController
    func tabBarController() -> UITabBarController
    
}

extension MainTabBarExternalDependency {
    func mainTabBarCoordinator(data: IdAccountDataProfileRepresentable?) -> Coordinator {
        MainTabBarCoordinatorImp(dependencies: self, data: data)
    }
}
