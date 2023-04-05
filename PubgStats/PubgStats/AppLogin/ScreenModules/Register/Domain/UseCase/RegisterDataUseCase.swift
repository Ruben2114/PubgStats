//
//  RegisterDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Foundation

protocol RegisterDataUseCase: CommonUseCase {
    func execute(name: String, password: String, email: String)
}

struct RegisterDataUseCaseImp: RegisterDataUseCase{
    private(set) var registerRepository: RegisterRepository
    
    func execute(name: String, password: String, email: String) {
        registerRepository.saveProfileModel(name: name, password: password, email: email)
    }
}

