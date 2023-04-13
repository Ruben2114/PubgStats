//
//  FavouriteExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol FavouriteExternalDependency {
    func resolve() -> AppDependencies
    func favouriteCoordinator() -> Coordinator
    func statsGeneralCoordinator() -> BindableCoordinator
    func favouriteNavigationController() -> UINavigationController
    func resolve() -> ProfileEntity
    func resolve() -> LocalDataProfileService
    func resolve() -> RemoteService
}
extension FavouriteExternalDependency {
    func favouriteCoordinator() -> Coordinator {
        FavouriteCoordinatorImp(dependencies: self)
    }
}
