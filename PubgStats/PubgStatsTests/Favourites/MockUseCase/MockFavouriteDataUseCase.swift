//
//  MockFavouriteDataUseCase.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

import PubgStats
import Combine
import Foundation

final class MockFavouriteDataUseCase: FavouriteDataUseCase {
    public var favouritesDataError = false
    public var newFavouritesDataError = false
    public var deleteFavouritesDataError = false
    
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error> {
        if favouritesDataError {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } else {
            return Just([MockIdAccountDataProfile(id: "1111", name: "name", platform: "steam")]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    func deleteFavouritePlayer(_ player: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error> {
        if deleteFavouritesDataError {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } else {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        if newFavouritesDataError {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } else {
            return Just(MockIdAccountDataProfile(id: "1111", name: name, platform: platform)).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
