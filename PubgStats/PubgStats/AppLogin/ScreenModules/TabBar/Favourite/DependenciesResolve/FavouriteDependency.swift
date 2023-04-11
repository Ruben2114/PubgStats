//
//  FavouriteDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol FavouriteDependency {
    var external: FavouriteExternalDependency { get }
    func resolve() -> FavouriteViewController
    func resolve() -> FavouriteViewModel
    func resolve() -> FavouriteCoordinator?
    func resolve() -> FavouriteDataUseCase
    func resolve() -> FavouriteRepository
}

extension FavouriteDependency {
    func resolve() -> FavouriteViewController {
        FavouriteViewController(dependencies: self)
    }
    func resolve() -> FavouriteViewModel {
        FavouriteViewModel(dependencies: self)
    }
    func resolve() -> FavouriteDataUseCase {
        FavouriteDataUseCaseImp(dependencies: self)
    }
    func resolve() -> FavouriteRepository {
        FavouriteRepositoryImp(dependencies: self)
    }
}
