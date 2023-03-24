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
    func favouriteNavigationController() -> UINavigationController
}
extension FavouriteExternalDependency {
    func favouriteCoordinator() -> Coordinator {
        FavouriteCoordinatorImp(dependencies: self)
    }
}