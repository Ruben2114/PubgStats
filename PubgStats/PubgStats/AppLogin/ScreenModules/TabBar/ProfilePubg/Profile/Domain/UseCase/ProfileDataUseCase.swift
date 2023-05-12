//
//  ProfileDataUseCase.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation

protocol ProfileDataUseCase: CommonUseCase {
    func execute(sessionUser: ProfileEntity, player: String, account: String, platform: String)
    func fetchPlayerData(name: String, platform: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void)
    func changeValue(sessionUser: ProfileEntity,_ value: String, type: String)
    func changeImage(sessionUser: ProfileEntity, image: Data)
    func deletePubgAccount(sessionUser: ProfileEntity)
}

struct ProfileDataUseCaseImp: ProfileDataUseCase{
    internal let commonRepository: CommonRepository
    private let profileRepository: ProfileRepository
    init(dependencies: ProfileDependency) {
        self.commonRepository = dependencies.external.resolve()
        self.profileRepository = dependencies.resolve()
    }
    func execute(sessionUser: ProfileEntity, player: String, account: String, platform: String) {
        return profileRepository.saveProfilePubg(sessionUser: sessionUser, player: player, account: account, platform: platform)
    }
    func fetchPlayerData(name: String, platform: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void) {
        profileRepository.fetchPlayerData(name: name, platform: platform, completion: completion)
    }
    func changeValue(sessionUser: ProfileEntity,_ value: String, type: String) {
        profileRepository.changeValue(sessionUser: sessionUser,value, type: type)
    }
    func changeImage(sessionUser: ProfileEntity, image: Data){
        profileRepository.changeImage(sessionUser: sessionUser, image: image)
    }
    func deletePubgAccount(sessionUser: ProfileEntity){
        profileRepository.deletePubgAccount(sessionUser: sessionUser)
    }
}
