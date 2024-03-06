//
//  FavouriteDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import Combine

protocol FavouriteDataUseCase {
    func saveFavouritePlayer(_ player: IdAccountDataProfileRepresentable)
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error>
    func deleteFavouritePlayer(_ player: IdAccountDataProfileRepresentable)
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error>
}

struct FavouriteDataUseCaseImp: FavouriteDataUseCase{
    private let favouriteRepository: FavouritePlayerRepository
    private let profileRepository: DataPlayerRepository
    init(dependencies: FavouriteDependencies) {
        self.favouriteRepository = dependencies.external.resolve()
        self.profileRepository = dependencies.external.resolve()
    }
    
    func saveFavouritePlayer(_ player: IdAccountDataProfileRepresentable) {
        favouriteRepository.actionFavouritePlayer(player, action: .save)
    }
    
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error> {
        favouriteRepository.getFavouritesPlayers().eraseToAnyPublisher()
    }
    
    func deleteFavouritePlayer(_ player: IdAccountDataProfileRepresentable){
        favouriteRepository.actionFavouritePlayer(player, action: .delete)
    }
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        profileRepository.fetchPlayerData(name: name, platform: platform).eraseToAnyPublisher()
    }
}
