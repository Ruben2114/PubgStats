//
//  SettingsExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol SettingsExternalDependency {
    func resolve() -> AppDependencies
    func settingsCoordinator() -> Coordinator
    func helpDataCoordinator() -> Coordinator
    func settingsNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> LocalDataProfileService
}
extension SettingsExternalDependency {
    func settingsCoordinator() -> Coordinator {
        SettingsCoordinatorImp(dependencies: self)
    }
}
