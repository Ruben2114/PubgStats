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
    func fetchPlayerData(name: String, platform: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void) {
    }
    func saveFav( player: String, account: String, platform: String) {
    }
    func getFavourites() -> [Favourite]?{
        return []
    }
    func deleteFavouriteTableView(_ profile: Favourite){
    }
}

