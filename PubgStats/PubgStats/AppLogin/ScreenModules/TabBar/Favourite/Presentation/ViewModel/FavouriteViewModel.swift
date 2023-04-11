//
//  FavouriteViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 5/4/23.
//

import Foundation
import Combine

final class FavouriteViewModel {
    var state = PassthroughSubject<OutputPlayer, Never>()
    private weak var coordinator: FavouriteCoordinator?
    private let dependencies: FavouriteDependency
    private let favouriteDataUseCase: FavouriteDataUseCase
    
    init(dependencies: FavouriteDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.favouriteDataUseCase = dependencies.resolve()
    }
    func searchFav(name: String){
        state.send(.loading)
        favouriteDataUseCase.fetchPlayerData(name: name) { [weak self] result in
            switch result {
            case .success(let player):
                self?.state.send(.success(model: player))
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
    }
    
    func saveFav(sessionUser: ProfileEntity, player: String, account: String) {
        favouriteDataUseCase.saveFav(sessionUser: sessionUser, player: player, account: account)
    }
    
    func getFavourites(for sessionUser: ProfileEntity) -> [Favourite]? {
        favouriteDataUseCase.getFavourites(for: sessionUser)
    }
    
    func deleteFavouriteTableView(_ profile: Favourite){
        favouriteDataUseCase.deleteFavouriteTableView(profile)
    }
}




