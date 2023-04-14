//
//  WeaponDataExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol WeaponDataExternalDependency {
    func resolve() -> AppDependencies
    func weaponDataCoordinator(navigation: UINavigationController) -> Coordinator
    func weaponDataDetailCoordinator(navigation: UINavigationController) -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> RemoteService
    func resolve() -> LocalDataProfileService
}

extension WeaponDataExternalDependency {
    func weaponDataCoordinator(navigation: UINavigationController) -> Coordinator {
        WeaponDataCoordinatorImp(dependencies: self, navigation: navigation)
    }
}

