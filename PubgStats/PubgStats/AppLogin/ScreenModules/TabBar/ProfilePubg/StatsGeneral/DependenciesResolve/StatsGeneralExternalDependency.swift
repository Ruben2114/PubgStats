//
//  StatsGeneralExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol StatsGeneralExternalDependency {
    func resolve() -> AppDependencies
    func statsGeneralCoordinator() -> BindableCoordinator
    func killsDataCoordinator(navigation: UINavigationController) -> Coordinator
    func weaponDataCoordinator(navigation: UINavigationController) -> Coordinator
    func gamesModesDataCoordinator(navigation: UINavigationController) -> Coordinator
    func survivalDataCoordinator(navigation: UINavigationController) -> Coordinator
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
    func statsGeneralCoordinator() -> BindableCoordinator {
        StatsGeneralCoordinatorImp(dependencies: self)
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
