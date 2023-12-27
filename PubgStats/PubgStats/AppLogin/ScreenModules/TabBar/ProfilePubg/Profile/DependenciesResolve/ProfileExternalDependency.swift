//
//  ProfileExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol ProfileExternalDependency {
    func resolve() -> AppDependencies
    func profileCoordinator() -> BindableCoordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> DataProfileRepository
}

extension ProfileExternalDependency {
    func profileCoordinator() -> BindableCoordinator {
        ProfileCoordinatorImp(dependencies: self)
    }
}
