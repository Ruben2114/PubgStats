//
//  ProfileDataUseCase.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//


protocol ProfileDataUseCase {
    func execute(player: String, account: String)
}

struct ProfileDataUseCaseImp: ProfileDataUseCase {
    private(set) var profileRepository: ProfileRepository

    func execute(player: String, account: String) {
        return profileRepository.saveProfilePubg(player: player, account: account)
    }
}
