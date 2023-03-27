//
//  ProfileRepositoryImp.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

struct ProfileRepositoryImp: ProfileRepository {
    var dataSource: LocalDataProfileService
    var remoteData: RemoteService

    func saveProfilePubg(sessionUser: ProfileEntity, player: String, account: String) {
        return dataSource.savePlayerPubg(sessionUser: sessionUser, player: player, account: account)
    }
    func fetchPlayerData(name: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void) {
        remoteData.getPlayerData(name: name, completion: completion)
    }
   
}
