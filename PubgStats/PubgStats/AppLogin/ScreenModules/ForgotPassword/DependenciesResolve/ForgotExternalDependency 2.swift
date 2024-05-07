//
//  ForgotExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

protocol ForgotExternalDependency {
    func resolve() -> AppDependencies
    func forgotCoordinator() -> Coordinator
    func loginNavigationController() -> UINavigationController
}

extension ForgotExternalDependency {
    func forgotCoordinator() -> Coordinator {
        ForgotCoordinatorImp(dependencies: self, navigation: loginNavigationController())
    }
}
