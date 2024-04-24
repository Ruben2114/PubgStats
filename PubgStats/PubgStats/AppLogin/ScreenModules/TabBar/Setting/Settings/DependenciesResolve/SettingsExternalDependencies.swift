//
//  SettingsExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol SettingsExternalDependencies {
    func settingsCoordinator(navigation: UINavigationController?) -> BindableCoordinator
    func helpDataCoordinator() -> Coordinator
    func infoAppCoordinator() -> Coordinator
    func resolve() -> DataPlayerRepository
}
extension SettingsExternalDependencies {
    func settingsCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        SettingsCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
