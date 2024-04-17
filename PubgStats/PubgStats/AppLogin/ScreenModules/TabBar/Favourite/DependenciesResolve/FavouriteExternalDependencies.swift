//
//  FavouriteExternalDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol FavouriteExternalDependencies {
    func favouriteCoordinator(navigation: UINavigationController?) -> Coordinator
    func resolve() -> FavouritePlayerRepository
    func resolve() -> DataPlayerRepository
    func profileCoordinator(navigation: UINavigationController?) -> BindableCoordinator
}
extension FavouriteExternalDependencies {
    func favouriteCoordinator(navigation: UINavigationController?) -> Coordinator {
        FavouriteCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
