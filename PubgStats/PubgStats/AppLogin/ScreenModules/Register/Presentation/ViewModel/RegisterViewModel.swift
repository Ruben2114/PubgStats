//
//  RegisterViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Foundation
import Combine

class RegisterViewModel {
    
    var state: PassthroughSubject<StateController, Never>
    private let registerDataUseCase: RegisterDataUseCase
    
    init(state: PassthroughSubject<StateController, Never>, registerDataUseCase: RegisterDataUseCase) {
        self.state = state
        self.registerDataUseCase = registerDataUseCase
    }
    //TODO: quitar de aqui el contexto
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    func saveUser(name: String, password: String) {
        state.send(.loading)
        Task {
            let newUser = Profile(context: context)
            newUser.name = name
            newUser.password = password
            _ = registerDataUseCase.execute(profile: newUser)
            state.send(.success)
        }
    }
    func checkName(name: String) -> Bool {
            let check = registerDataUseCase.check(name: name)
            return check
    }
}

