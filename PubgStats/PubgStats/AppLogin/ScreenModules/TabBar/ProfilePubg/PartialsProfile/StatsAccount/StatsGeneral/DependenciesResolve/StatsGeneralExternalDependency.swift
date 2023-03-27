//
//  StatsGeneralExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol StatsGeneralExternalDependency {
    func resolve() -> AppDependencies
    func statsGeneralCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
}

extension StatsGeneralExternalDependency {
    func statsGeneralCoordinator() -> Coordinator {
        StatsGeneralCoordinatorImp(dependencies: self, navigation: profileNavigationController())
    }
}
