//
//  RegisterDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Foundation

protocol RegisterDataUseCase {
    func execute(name: String, password: String)
    func check(name: String) -> Bool
}

struct RegisterDataUseCaseImp: RegisterDataUseCase{
    private let registerRepository: RegisterRepository
    
    init(registerRepository: RegisterRepository) {
        self.registerRepository = registerRepository
    }
    func execute(name: String, password: String) {
        return registerRepository.saveProfileModel(name: name, password: password)
    }
    func check(name: String) -> Bool {
        registerRepository.checkName(name: name)
    }
}

