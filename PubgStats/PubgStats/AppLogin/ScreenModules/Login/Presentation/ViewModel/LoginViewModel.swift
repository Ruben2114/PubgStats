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
    
    func check(sessionUser: ProfileEntity, name: String, password: String) {
        state.send(.loading)
        loginSucess(name: name, password: password)
        Task { [weak self] in
            guard let check = self?.loginDataUseCase.check(sessionUser: sessionUser ,name: name, password: password) else {return}
            switch check {
            case true:
                self?.state.send(.success)
                self?.coordinator?.performTransition(.goProfile)
            case false:
                self?.state.send(.fail(error: "Nombre o contraseña incorrecto."))
            }
        }
    }
    func loginSucess(name: String, password: String) {
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        sessionUser.name = name
        sessionUser.password = password
    }
    func didTapForgotButton() {
        coordinator?.performTransition(.goForgot)
    }
    func didTapRegisterButton() {
        coordinator?.performTransition(.goRegister)
    }
}
