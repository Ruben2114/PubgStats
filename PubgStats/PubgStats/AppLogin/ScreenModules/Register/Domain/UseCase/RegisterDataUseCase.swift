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
    internal let commonRepository: CommonRepository
    private let registerRepository: RegisterRepository
    
    init(dependencies: RegisterDependency) {
        self.commonRepository = dependencies.external.resolve()
        self.registerRepository = dependencies.resolve()
    }
    
    func execute(name: String, password: String, email: String) {
        registerRepository.saveProfileModel(name: name, password: password, email: email)
    }
}

