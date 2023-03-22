//
//  ProfileRepositoryImp.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

struct ProfileRepositoryImp: ProfileRepository {
    var dataSource: LocalDataProfileService

    func saveProfilePubg(player: String, account: String) {
        return dataSource.save(player: player, account: account)
    }
}
