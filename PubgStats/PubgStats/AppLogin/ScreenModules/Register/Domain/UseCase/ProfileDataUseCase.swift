//
//  ProfileDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Foundation

protocol ProfileDataUseCase {
    func execute(profile: ProfileModel) async -> Result<Bool, ProfileError>
}

struct ProfileDataUseCaseImp: ProfileDataUseCase{
    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    func execute(profile: ProfileModel) async -> Result<Bool, ProfileError> {
        return await profileRepository.saveProfileModel(profile: profile)
    }
}

