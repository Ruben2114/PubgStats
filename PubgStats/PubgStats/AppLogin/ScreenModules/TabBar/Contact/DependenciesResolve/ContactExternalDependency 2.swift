//
//  ContactExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol ContactExternalDependency {
    func resolve() -> AppDependencies
    func contactCoordinator() -> Coordinator
    func contactNavigationController() -> UINavigationController
}
extension ContactExternalDependency {
    func contactCoordinator() -> Coordinator {
        ContactCoordinatorImp(dependencies: self)
    }
}
