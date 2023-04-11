//
//  HelpDataExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

import UIKit

protocol HelpDataExternalDependency {
    func resolve() -> AppDependencies
    func helpDataCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
}

extension HelpDataExternalDependency {
    func helpDataCoordinator() -> Coordinator {
        HelpDataCoordinatorImp(dependencies: self, navigation: profileNavigationController())
    }
}
