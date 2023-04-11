//
//  KillsDataExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol KillsDataExternalDependency {
    func resolve() -> AppDependencies
    func killsDataCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> LocalDataProfileService
}

extension KillsDataExternalDependency {
    func killsDataCoordinator() -> Coordinator {
        KillsDataCoordinatorImp(dependencies: self, navigation: profileNavigationController())
    }
}
