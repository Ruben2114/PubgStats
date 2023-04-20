//
//  WeaponDataDetailExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

import UIKit

protocol WeaponDataDetailExternalDependency {
    func resolve() -> AppDependencies
    func weaponDataDetailCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
}

extension WeaponDataDetailExternalDependency {
    func weaponDataDetailCoordinator() -> Coordinator {
        WeaponDataDetailCoordinatorImp(dependencies: self, navigation: profileNavigationController())
    }
}
