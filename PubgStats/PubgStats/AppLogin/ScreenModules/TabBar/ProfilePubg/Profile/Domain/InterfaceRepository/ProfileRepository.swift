//
//  ProfileRepository.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

protocol ProfileRepository {
    func saveProfilePubg (sessionUser: ProfileEntity, player: String, account: String)
    func fetchPlayerData(name: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void)
    func changeValue(sessionUser: ProfileEntity,_ value: String, type: String)
}

