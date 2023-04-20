//
//  FavouriteRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

struct FavouriteRepositoryImp: FavouriteRepository {
    private let dataSource: LocalDataProfileService
    private let remoteData: RemoteService
    
    init(dependencies: FavouriteDependency) {
        self.dataSource = dependencies.external.resolve()
        self.remoteData = dependencies.external.resolve()
    }
    func fetchPlayerData(name: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void) {
        remoteData.getPlayerData(name: name, completion: completion)
    }
    func saveFav(sessionUser: ProfileEntity, player: String, account: String) {
        dataSource.saveFav(sessionUser: sessionUser, name: player, account: account)
    }
    func getFavourites(for sessionUser: ProfileEntity) -> [Favourite]?{
        dataSource.getFavourites(for: sessionUser)
    }
    func deleteFavouriteTableView(_ profile: Favourite){
        dataSource.deleteFavouriteTableView(profile)
    }
}

