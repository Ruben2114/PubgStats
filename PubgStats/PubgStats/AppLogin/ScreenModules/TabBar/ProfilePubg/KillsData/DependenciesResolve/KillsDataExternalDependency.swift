//
//  KillsDataExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol KillsDataExternalDependency {
    func resolve() -> AppDependencies
    func killsDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func resolve() -> LocalDataProfileService
}

extension KillsDataExternalDependency {
    func killsDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator {
        KillsDataCoordinatorImp(dependencies: self, navigation: navigation, type: type)
    }
}
