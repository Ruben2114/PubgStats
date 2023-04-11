//
//  GamesModesDataExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

protocol GamesModesDataExternalDependency {
    func resolve() -> AppDependencies
    func gamesModesDataCoordinator() -> Coordinator
    func gamesModesDataDetailCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> LocalDataProfileService
}

extension GamesModesDataExternalDependency {
    func gamesModesDataCoordinator() -> Coordinator {
        GamesModesDataCoordinatorImp(dependencies: self, navigation: profileNavigationController())
    }
}
