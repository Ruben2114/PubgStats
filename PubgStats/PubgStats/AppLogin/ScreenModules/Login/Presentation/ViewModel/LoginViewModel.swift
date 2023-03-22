//
//  LoginViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation
import Combine

final class LoginViewModel {
    var state = PassthroughSubject<StateController, Never>()
    private var coordinator: LoginCoordinator
    private let loginDataUseCase: LoginDataUseCase
    private let dependencies: LoginDependency
    
    init(dependencies: LoginDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.loginDataUseCase = dependencies.resolve()
    }
    
    func checkName(name: String, password: String) {
        state.send(.loading)
        Task {
            let check = loginDataUseCase.check(name: name, password: password)
            switch check {
            case true:
                state.send(.success)
            case false:
                state.send(.fail(error: "Incorrect username or password."))
            }
        }
    }
    func didTapForgotButton() {
        coordinator.performTransition(.goForgot)
    }
}
