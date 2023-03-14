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
    private let registerRepository: RegisterRepository
    
    init(registerRepository: RegisterRepository) {
        self.registerRepository = registerRepository
    }
    func execute(profile: Profile){
        return  registerRepository.saveProfileModel(profile: profile)
    }
}

