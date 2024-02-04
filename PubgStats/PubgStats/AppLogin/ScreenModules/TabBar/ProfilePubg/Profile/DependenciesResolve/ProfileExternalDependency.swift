//
//  ProfileExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol ProfileExternalDependency {
    func resolve() -> AppDependencies
    func profileCoordinator(navigation: UINavigationController) -> BindableCoordinator
    func resolve() -> DataProfileRepository
    func attributesHomeCoordinator(navigation: UINavigationController) -> BindableCoordinator
}

extension ProfileExternalDependency {
    func profileCoordinator(navigation: UINavigationController) -> BindableCoordinator {
        ProfileCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
