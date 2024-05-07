//
//  MainTabBarExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol MainTabBarExternalDependencies {
    func mainTabBarCoordinator(data: IdAccountDataProfileRepresentable?) -> Coordinator
    func profileCoordinator(navigation: UINavigationController?) -> BindableCoordinator
    func favouriteCoordinator(navigation: UINavigationController?) -> Coordinator
    func settingsCoordinator(navigation: UINavigationController?) -> BindableCoordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func settingsNavigationController() -> UINavigationController
}

extension MainTabBarExternalDependencies {
    func mainTabBarCoordinator(data: IdAccountDataProfileRepresentable?) -> Coordinator {
        MainTabBarCoordinatorImp(dependencies: self, data: data)
    }
}
