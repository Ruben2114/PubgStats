//
//  SurvivalDataExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import UIKit

protocol SurvivalDataExternalDependency {
    func resolve() -> AppDependencies
    func survivalDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> LocalDataProfileService
}

extension SurvivalDataExternalDependency {
    func survivalDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator {
        SurvivalDataCoordinatorImp(dependencies: self, navigation: navigation, type: type)
    }
}