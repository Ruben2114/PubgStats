//
//  FavouriteDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol FavouriteDependencies {
    var external: FavouriteExternalDependencies { get }
    func resolve() -> FavouriteViewController
    func resolve() -> FavouriteViewModel
    func resolve() -> FavouriteCoordinator
    func resolve() -> FavouriteDataUseCase
}

extension FavouriteDependencies {
    func resolve() -> FavouriteViewController {
        FavouriteViewController(dependencies: self)
    }
    
    func resolve() -> FavouriteViewModel {
        FavouriteViewModel(dependencies: self)
    }
    
    func resolve() -> FavouriteDataUseCase {
        FavouriteDataUseCaseImp(dependencies: self)
    }
}
