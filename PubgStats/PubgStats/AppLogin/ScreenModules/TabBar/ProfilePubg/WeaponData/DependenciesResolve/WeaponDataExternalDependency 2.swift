//
//  WeaponDataExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol WeaponDataExternalDependency {
    func resolve() -> AppDependencies
    func weaponDataCoordinator() -> Coordinator
    func weaponDataDetailCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
}

extension WeaponDataExternalDependency {
    func weaponDataCoordinator() -> Coordinator {
        WeaponDataCoordinatorImp(dependencies: self, navigation: profileNavigationController())
    }
}
