//
//  StatsGeneralExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol StatsGeneralExternalDependency {
    func resolve() -> AppDependencies
    func statsGeneralCoordinator(type: NavigationStats) -> BindableCoordinator
    func killsDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
    func weaponDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
    func gamesModesDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
    func survivalDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
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
    func statsGeneralCoordinator(type: NavigationStats) -> BindableCoordinator {
        StatsGeneralCoordinatorImp(dependencies: self, type: type)
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
