//
//  ProfileExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol ProfileExternalDependency {
    func resolve() -> AppDependencies
    func profileCoordinator() -> Coordinator
    func helpDataCoordinator() -> Coordinator
    func statsGeneralCoordinator(navigationType: NavigationType) -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> CommonRepository
    func resolve() -> LocalDataProfileService
    func resolve() -> RemoteService
}
extension ProfileExternalDependency {
    func profileCoordinator() -> Coordinator {
        ProfileCoordinatorImp(dependencies: self)
    }
}
