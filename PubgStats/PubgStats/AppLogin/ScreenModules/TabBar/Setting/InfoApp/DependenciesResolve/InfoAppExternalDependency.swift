//
//  InfoAppExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

import UIKit

protocol InfoAppExternalDependency {
    func resolve() -> AppDependencies
    func infoAppCoordinator() -> Coordinator
    func settingsNavigationController() -> UINavigationController
}

extension InfoAppExternalDependency {
    func infoAppCoordinator() -> Coordinator {
        InfoAppCoordinatorImp(dependencies: self, navigation: settingsNavigationController())
    }
}
