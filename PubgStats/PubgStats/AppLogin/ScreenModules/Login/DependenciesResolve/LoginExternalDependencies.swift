//
//  LoginExternalDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

protocol LoginExternalDependencies {
    func loginCoordinator() -> Coordinator
    func loginNavigationController() -> UINavigationController
    func resolve() -> DataProfileRepository
}

extension LoginExternalDependencies {
    func loginCoordinator() -> Coordinator {
        LoginCoordinatorImp(dependencies: self, navigation: loginNavigationController())
    }
}
