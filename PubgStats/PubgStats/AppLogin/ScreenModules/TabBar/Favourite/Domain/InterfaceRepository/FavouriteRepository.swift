//
//  FavouriteRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

protocol FavouriteRepository {
    func saveFav(sessionUser: ProfileEntity, player: String, account: String, platform: String)
    func fetchPlayerData(name: String, platform: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void)
    func getFavourites(for sessionUser: ProfileEntity) -> [Favourite]?
    func deleteFavouriteTableView(_ profile: Favourite)
}
