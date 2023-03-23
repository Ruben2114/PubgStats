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
    weak private var coordinator: LoginCoordinator?
    private let loginDataUseCase: LoginDataUseCase
    private let dependencies: LoginDependency
    
    init(dependencies: LoginDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.loginDataUseCase = dependencies.resolve()
    }
    
    func checkName(name: String, password: String) {
        state.send(.loading)
        Task { [weak self] in
            let check = loginDataUseCase.check(name: name, password: password)
            switch check {
            case true:
                self?.state.send(.success)
                self?.loginSucess(name: name, password: password)
            case false:
                self?.state.send(.fail(error: "Incorrect username or password."))
            }
        }
    }
    func loginSucess(name: String, password: String) {
        var sessionUser: ProfileEntity = dependencies.external.resolve()
        sessionUser.name = name
        sessionUser.password = password
        var sessionUser2: ProfileEntity = dependencies.external.resolve()
        coordinator?.performTransition(.goProfile)
    }
    func didTapForgotButton() {
        coordinator?.performTransition(.goForgot)
    }
    func didTapRegisterButton() {
        coordinator?.performTransition(.goRegister)
    }
}
