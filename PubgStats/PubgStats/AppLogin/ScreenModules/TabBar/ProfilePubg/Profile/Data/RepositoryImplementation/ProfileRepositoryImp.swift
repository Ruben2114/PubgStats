//
//  ProfileRepositoryImp.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

struct ProfileRepositoryImp: ProfileRepository {
    var dataSource: LocalDataProfileService

    func saveProfilePubg(sessionUser: ProfileEntity, player: String, account: String) {
        return dataSource.savePlayerPubg(sessionUser: sessionUser, player: player, account: account)
    }
}
