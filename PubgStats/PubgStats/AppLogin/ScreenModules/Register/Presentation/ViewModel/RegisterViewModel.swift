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
    func saveUser(name: String, password: String) {
        state.send(.loading)
        registerDataUseCase.execute(name: name, password: password)
        state.send(.success)
    }
    func checkName(name: String) -> Bool {
        let check = registerDataUseCase.check(name: name)
        return check
    }
    func didTapAcceptButton() {
        coordinator?.performTransition(.goAccept)
    }
    func backButton() {
        coordinator?.dismiss()
    }
}

