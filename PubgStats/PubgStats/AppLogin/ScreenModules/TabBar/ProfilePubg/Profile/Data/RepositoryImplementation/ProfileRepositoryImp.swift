//
//  ProfileRepositoryImp.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation

struct ProfileRepositoryImp: ProfileRepository {
    private let dataSource: LocalDataProfileService
    private let remoteData: RemoteService
    init(dependencies: ProfileDependency) {
        self.dataSource = dependencies.external.resolve()
        self.remoteData = dependencies.external.resolve()
    }

    func saveProfilePubg(sessionUser: ProfileEntity, player: String, account: String) {
        return dataSource.savePlayerPubg(sessionUser: sessionUser, player: player, account: account)
    }
    func fetchPlayerData(name: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void) {
        remoteData.getPlayerData(name: name, completion: completion)
    }
    func changeValue(sessionUser: ProfileEntity,_ value: String, type: String){
        dataSource.saveNewValue(sessionUser: sessionUser,value, type: type)
    }
    func changeImage(sessionUser: ProfileEntity, image: Data) {
        dataSource.saveNewValue(sessionUser: sessionUser, image, type: "image")
    }
    func deletePubgAccount(sessionUser: ProfileEntity){
        dataSource.deletePubgAccount(sessionUser: sessionUser)
    }
}
