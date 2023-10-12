//
//  GamesModesDataExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

protocol GamesModesDataExternalDependency {
    func resolve() -> AppDependencies
    func gamesModesDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
    func gamesModesDataDetailCoordinator(navigation: UINavigationController) -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func resolve() -> LocalDataProfileService
}

extension GamesModesDataExternalDependency {
    func gamesModesDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator {
        GamesModesDataCoordinatorImp(dependencies: self, navigation: navigation, type: type)
    }
}
