//
//  FavouritePlayerRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import Combine

public protocol FavouritePlayerRepository {
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error>
    func deleteFavouritePlayer(_ profile: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error>
}

struct FavouriteRepositoryImp: FavouritePlayerRepository {
    private let dataSource: LocalDataProfileService
    
    init(dependencies: AppDependencies) {
        self.dataSource = dependencies.resolve()
    }
    
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error> {
        dataSource.getFavourites().eraseToAnyPublisher()
    }

    func deleteFavouritePlayer(_ profile: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error> {
        dataSource.deleteFavourite(profile).eraseToAnyPublisher()
    }
}
