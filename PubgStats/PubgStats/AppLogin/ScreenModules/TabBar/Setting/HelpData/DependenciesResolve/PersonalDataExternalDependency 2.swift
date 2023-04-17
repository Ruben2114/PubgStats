//
//  PersonalDataExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

import UIKit

protocol PersonalDataExternalDependency {
    func resolve() -> AppDependencies
    func personalDataCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
}

extension PersonalDataExternalDependency {
    func personalDataCoordinator() -> Coordinator {
        PersonalDataCoordinatorImp(dependencies: self, navigation: profileNavigationController())
    }
}
