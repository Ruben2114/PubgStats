//
//  FavouriteDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

protocol FavouriteDataUseCase {
    func saveFav(sessionUser: ProfileEntity, player: String, account: String)
    func fetchPlayerData(name: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void)
    func getFavourites(for sessionUser: ProfileEntity) -> [Favourite]?
    func deleteFavouriteTableView(_ profile: Favourite)
}

struct FavouriteDataUseCaseImp: FavouriteDataUseCase{
    private let favouriteRepository: FavouriteRepository
    init(dependencies: FavouriteDependency) {
        self.favouriteRepository = dependencies.resolve()
    }
    func fetchPlayerData(name: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void) {
        favouriteRepository.fetchPlayerData(name: name, completion: completion)
    }
    func saveFav(sessionUser: ProfileEntity, player: String, account: String) {
        favouriteRepository.saveFav(sessionUser: sessionUser, player: player, account: account)
    }
    func getFavourites(for sessionUser: ProfileEntity) -> [Favourite]?{
        favouriteRepository.getFavourites(for: sessionUser)
    }
    func deleteFavouriteTableView(_ profile: Favourite){
        favouriteRepository.deleteFavouriteTableView(profile)
    }
}

