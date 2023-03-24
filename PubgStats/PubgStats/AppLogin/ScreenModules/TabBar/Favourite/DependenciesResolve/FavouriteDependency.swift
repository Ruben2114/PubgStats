//
//  FavouriteDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol FavouriteDependency {
    var external: FavouriteExternalDependency { get }
    func resolve() -> FavouriteViewController
    func resolve() -> FavouriteCoordinator
}

extension FavouriteDependency {
    func resolve() -> FavouriteViewController {
        FavouriteViewController(dependencies: self)
    }
}
