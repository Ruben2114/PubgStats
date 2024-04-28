//
//  MockFavouritePlayerRepository.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

import Foundation
import Combine
import PubgStats

struct MockFavouritePlayerRepository: FavouritePlayerRepository {
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error> {
        return Just([MockIdAccountDataProfile(id: "1111", name: "name", platform: "steam")]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func deleteFavouritePlayer(_ profile: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error> {
        if profile.name.isEmpty || profile.platform.isEmpty {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } else {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
