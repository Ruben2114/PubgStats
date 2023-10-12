//
//  FavouriteDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

protocol FavouriteDataUseCase {
    func saveFav(player: String, account: String, platform: String)
    func fetchPlayerData(name: String, platform: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void)
    func getFavourites() -> [Favourite]?
    func deleteFavouriteTableView(_ profile: Favourite)
}

struct FavouriteDataUseCaseImp: FavouriteDataUseCase{
    private let favouriteRepository: FavouriteRepository
    init(dependencies: FavouriteDependency) {
        self.favouriteRepository = dependencies.resolve()
    }
    func fetchPlayerData(name: String, platform: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void) {
        favouriteRepository.fetchPlayerData(name: name, platform: platform, completion: completion)
    }
    func saveFav(player: String, account: String, platform: String) {
        favouriteRepository.saveFav(player: player, account: account, platform: platform)
    }
    func getFavourites() -> [Favourite]?{
        favouriteRepository.getFavourites()
    }
    func deleteFavouriteTableView(_ profile: Favourite){
        favouriteRepository.deleteFavouriteTableView(profile)
    }
}

