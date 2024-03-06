//
//  FavouritePlayerRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import Combine

public enum ActionFavourite {
    case save
    case delete
}

protocol FavouritePlayerRepository {
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error>
    func actionFavouritePlayer(_ profile: IdAccountDataProfileRepresentable, action: ActionFavourite)
}

struct FavouriteRepositoryImp: FavouritePlayerRepository {
    private let dataSource: LocalDataProfileService
    
    init(dependencies: AppDependencies) {
        self.dataSource = dependencies.resolve()
    }
    
    func getFavouritesPlayers() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error> {
        //TODO: implementar
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func actionFavouritePlayer(_ profile: IdAccountDataProfileRepresentable, action: ActionFavourite) {
        //TODO: implementar
        switch action {
        case .save:
            break
        case .delete:
            break
        }
    }

}
