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
    //func personalDataCoordinator() -> Coordinator
    //func settingCoordinator() -> Coordinator
    func statsGeneralCoordinator() -> Coordinator
    func profileNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
}
extension ProfileExternalDependency {
    func profileCoordinator() -> Coordinator {
        ProfileCoordinatorImp(dependencies: self)
    }
}
