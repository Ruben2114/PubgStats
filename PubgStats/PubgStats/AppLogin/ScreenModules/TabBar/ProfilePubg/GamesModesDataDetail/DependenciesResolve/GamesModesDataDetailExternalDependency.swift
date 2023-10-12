//
//  GamesModesDataDetailExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

protocol GamesModesDataDetailExternalDependency {
    func resolve() -> AppDependencies
    func gamesModesDataDetailCoordinator(navigation: UINavigationController) -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
}

extension GamesModesDataDetailExternalDependency {
    func gamesModesDataDetailCoordinator(navigation: UINavigationController) -> Coordinator {
        GamesModesDataDetailCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
