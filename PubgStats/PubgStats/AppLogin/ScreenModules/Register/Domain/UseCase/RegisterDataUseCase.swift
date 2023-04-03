//
//  RegisterDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Foundation

protocol RegisterDataUseCase {
    func execute(name: String, password: String, email: String)
    func check(_ value: String?, type: String) -> Bool
}

struct RegisterDataUseCaseImp: RegisterDataUseCase{
    private let registerRepository: RegisterRepository
    
    init(registerRepository: RegisterRepository) {
        self.registerRepository = registerRepository
    }
    func execute(name: String, password: String, email: String) {
        return registerRepository.saveProfileModel(name: name, password: password, email: email)
    }
    func check(_ value: String?, type: String) -> Bool {
        guard let value = value else { return false }
        if type == "name" {
            return registerRepository.checkName(name: value)
        } else if type == "email" {
            return registerRepository.checkEmail(email: value)
        }
        return false
    }

}

