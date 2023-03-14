//
//  RegisterDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Foundation

protocol RegisterDataUseCase {
    func execute(profile: Profile)
}

struct RegisterDataUseCaseImp: RegisterDataUseCase{
    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    func execute(profile: Profile){
        return  profileRepository.saveProfileModel(profile: profile)
    }
}

