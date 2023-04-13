//
//  StatsGeneralExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol StatsGeneralExternalDependency {
    func resolve() -> AppDependencies
    func statsGeneralCoordinator(navigationType: NavigationStats) -> Coordinator
    func killsDataCoordinator() -> Coordinator
    func weaponDataCoordinator() -> Coordinator
    func gamesModesDataCoordinator() -> Coordinator
    func survivalDataCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> RemoteService
    func resolve() -> LocalDataProfileService
}
enum NavigationStats {
    case profile
    case favourite
}

extension StatsGeneralExternalDependency {
    func statsGeneralCoordinator(navigationType: NavigationStats) -> Coordinator {
        StatsGeneralCoordinatorImp(dependencies: self, navigation: navigationController(for: navigationType))
    }
    private func navigationController(for type: NavigationStats) -> UINavigationController {
        switch type {
        case .profile:
            return profileNavigationController()
        case .favourite:
            return favouriteNavigationController()
        }
    }
}
