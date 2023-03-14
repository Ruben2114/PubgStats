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
    func saveUser(name: String, password: String) {
        state.send(.loading)
        Task {
            _ = registerDataUseCase.execute(name: name, password: password)
            state.send(.success)
        }
    }
    func checkName(name: String) -> Bool {
        let check = registerDataUseCase.check(name: name)
        return check
    }
}

