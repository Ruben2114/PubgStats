//
//  ProfileExternalDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol ProfileExternalDependencies {
    func profileCoordinator(navigation: UINavigationController?) -> BindableCoordinator
    func resolve() -> DataPlayerRepository
    func attributesHomeCoordinator(navigation: UINavigationController?) -> BindableCoordinator
    func attributesDetailCoordinator(navigation: UINavigationController?) -> BindableCoordinator
    func matchesCoordinator(navigation: UINavigationController?) -> BindableCoordinator
}

extension ProfileExternalDependencies {
    func profileCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        ProfileCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
