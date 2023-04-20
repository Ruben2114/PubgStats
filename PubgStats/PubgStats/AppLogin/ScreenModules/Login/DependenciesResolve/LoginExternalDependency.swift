//
//  LoginExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

protocol LoginExternalDependency {
    func resolve() -> AppDependencies
    func mainTabBarCoordinator() -> Coordinator
    func forgotCoordinator() -> Coordinator
    func registerCoordinator() -> Coordinator
    func loginCoordinator() -> Coordinator
    func loginNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> LocalDataProfileService
}

extension LoginExternalDependency {
    func loginCoordinator() -> Coordinator {
        LoginCoordinatorImp(dependencies: self)
    }
}
