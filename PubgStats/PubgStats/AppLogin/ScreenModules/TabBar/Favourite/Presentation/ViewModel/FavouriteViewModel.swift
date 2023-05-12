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
    private let sessionUser: ProfileEntity
    init(dependencies: FavouriteDependency) {
        self.dependencies = dependencies
        self.sessionUser = dependencies.external.resolve()
        self.coordinator = dependencies.resolve()
        self.favouriteDataUseCase = dependencies.resolve()
    }
    func searchFav(name: String, platform: String){
        state.send(.loading)
        favouriteDataUseCase.fetchPlayerData(name: name, platform: platform) { [weak self] result in
            switch result {
            case .success(let player):
                guard let account = player.id, !account.isEmpty, let playerName = player.name, !playerName.isEmpty, let user = self?.sessionUser else {return}
                self?.saveFav(sessionUser: user, player: playerName, account: account, platform: platform)
                self?.state.send(.success(model: player))
            case .failure(_):
                self?.state.send(.fail(error: "errorFavouriteViewModel".localize()))
            }
        }
    }
    func saveFav(sessionUser: ProfileEntity, player: String, account: String, platform: String) {
        favouriteDataUseCase.saveFav(sessionUser: sessionUser, player: player, account: account, platform: platform)
    }
    func getFavourites(for sessionUser: ProfileEntity) -> [Favourite]? {
        favouriteDataUseCase.getFavourites(for: sessionUser)
    }
    func deleteFavouriteTableView(_ profile: Favourite){
        favouriteDataUseCase.deleteFavouriteTableView(profile)
    }
    func goFavourite(favourite: Favourite){
        sessionUser.nameFavourite = favourite.name
        sessionUser.accountFavourite = favourite.account
        sessionUser.platformFavourite = favourite.platform
        coordinator?.performTransition(.goStats)
    }
}

