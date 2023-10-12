//
//  WeaponDataExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol WeaponDataExternalDependency {
    func resolve() -> AppDependencies
    func weaponDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
    func weaponDataDetailCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func resolve() -> RemoteService
    func resolve() -> LocalDataProfileService
}

extension WeaponDataExternalDependency {
    func weaponDataCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator {
        WeaponDataCoordinatorImp(dependencies: self, navigation: navigation, type: type)
    }
}

