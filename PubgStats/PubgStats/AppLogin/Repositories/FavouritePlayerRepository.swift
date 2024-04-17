//
//  FavouritePlayerRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import Combine

protocol FavouritePlayerRepository {
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error>
    func deleteFavouritePlayer(_ profile: IdAccountDataProfileRepresentable)
}

struct FavouriteRepositoryImp: FavouritePlayerRepository {
    private let dataSource: LocalDataProfileService
    
    init(dependencies: AppDependencies) {
        self.dataSource = dependencies.resolve()
    }
    
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error> {
        dataSource.getFavourites().eraseToAnyPublisher()
    }
    
    func deleteFavouritePlayer(_ profile: IdAccountDataProfileRepresentable) {
        dataSource.deleteFavourite(profile)
    }
}
