//
//  WeaponDataDetailExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

import UIKit

protocol WeaponDataDetailExternalDependency {
    func resolve() -> AppDependencies
    func weaponDataDetailCoordinator(navigation: UINavigationController) -> Coordinator
    func profileNavigationController() -> UINavigationController
    func favouriteNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> LocalDataProfileService
}

extension WeaponDataDetailExternalDependency {
    func weaponDataDetailCoordinator(navigation: UINavigationController) -> Coordinator {
        WeaponDataDetailCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
