//
//  FavouriteDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import Combine

public protocol FavouriteDataUseCase {
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error>
    func deleteFavouritePlayer(_ player: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error>
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error>
}

struct FavouriteDataUseCaseImp: FavouriteDataUseCase{
    private let favouriteRepository: FavouritePlayerRepository
    private let profileRepository: DataPlayerRepository
    init(dependencies: FavouriteDependencies) {
        self.favouriteRepository = dependencies.external.resolve()
        self.profileRepository = dependencies.external.resolve()
    }
    
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error> {
        favouriteRepository.getFavouritesPlayers().eraseToAnyPublisher()
    }
    
    func deleteFavouritePlayer(_ player: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error> {
        favouriteRepository.deleteFavouritePlayer(player).eraseToAnyPublisher()
    }
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        profileRepository.fetchPlayerData(name: name, platform: platform, type: .favourite).eraseToAnyPublisher()
    }
}
