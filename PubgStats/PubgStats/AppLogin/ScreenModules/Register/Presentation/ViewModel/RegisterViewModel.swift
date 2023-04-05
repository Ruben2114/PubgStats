//
//  RegisterViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Foundation
import Combine

final class RegisterViewModel {
    var state = PassthroughSubject<StateController, Never>()
    private var coordinator: RegisterCoordinator?
    private let registerDataUseCase: RegisterDataUseCase
    private let dependencies: RegisterDependency
    
    
    init(dependencies: RegisterDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.registerDataUseCase = dependencies.resolve()
    }
    func saveUser(name: String, password: String, email: String) {
        state.send(.loading)
        registerDataUseCase.execute(name: name, password: password, email: email)
        state.send(.success)
    }
    func checkName(name: String) -> Bool {
        let check = registerDataUseCase.check(name,type: "name")
        return check
    }
    func checkEmail(email: String) -> Bool {
        let check = registerDataUseCase.check(email,type: "email")
        return check
    }
    
    func backButton() {
        coordinator?.dismiss()
    }
}

