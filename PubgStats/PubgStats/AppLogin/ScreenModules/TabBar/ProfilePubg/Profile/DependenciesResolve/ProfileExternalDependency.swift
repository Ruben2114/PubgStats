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
    func statsGeneralCoordinator(navigation: UINavigationController, type: NavigationStats) -> Coordinator
    func profileNavigationController() -> UINavigationController
}

extension ProfileExternalDependency {
    func profileCoordinator() -> BindableCoordinator {
        ProfileCoordinatorImp(dependencies: self)
    }
}
