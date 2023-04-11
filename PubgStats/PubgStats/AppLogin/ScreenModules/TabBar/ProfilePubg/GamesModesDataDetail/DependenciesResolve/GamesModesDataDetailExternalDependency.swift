//
//  GamesModesDataDetailExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

protocol GamesModesDataDetailExternalDependency {
    func resolve() -> AppDependencies
    func gamesModesDataDetailCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
}

extension GamesModesDataDetailExternalDependency {
    func gamesModesDataDetailCoordinator() -> Coordinator {
        GamesModesDataDetailCoordinatorImp(dependencies: self, navigation: profileNavigationController())
    }
}
