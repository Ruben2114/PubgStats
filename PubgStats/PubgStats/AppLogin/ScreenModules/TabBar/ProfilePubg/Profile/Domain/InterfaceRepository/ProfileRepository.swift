//
//  ProfileRepository.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation

protocol ProfileRepository {
    func saveProfilePubg (sessionUser: ProfileEntity, player: String, account: String, platform: String)
    func fetchPlayerData(name: String, platform: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void)
    func changeValue(sessionUser: ProfileEntity,_ value: String, type: String)
    func changeImage(sessionUser: ProfileEntity, image: Data)
    func deletePubgAccount(sessionUser: ProfileEntity)
}

