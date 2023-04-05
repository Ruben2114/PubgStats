//
//  RegisterExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

protocol RegisterExternalDependency {
    func resolve() -> AppDependencies
    func registerCoordinator() -> Coordinator
    func loginNavigationController() -> UINavigationController
    func resolve() -> LocalDataProfileService
}

extension RegisterExternalDependency {
    func registerCoordinator() -> Coordinator {
        RegisterCoordinatorImp(dependencies: self, navigation: loginNavigationController())
    }
}

