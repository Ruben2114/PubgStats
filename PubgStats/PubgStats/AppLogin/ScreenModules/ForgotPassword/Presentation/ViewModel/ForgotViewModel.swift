//
//  ForgotViewModel.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//
import Combine

final class ForgotViewModel {
    var state = PassthroughSubject<StateController, Never>()
    private let forgotDataUseCase: ForgotDataUseCase
    private let dependencies: ForgotDependency
    private weak var coordinator: ForgotCoordinator?
    
    init(dependencies: ForgotDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.forgotDataUseCase = dependencies.resolve()
    }
    func checkAndChangePassword(name: String, email: String) {
        state.send(.loading)
        Task { [weak self] in
            let check = forgotDataUseCase.check(name: name, email: email)
            switch check {
            case true:
                self?.state.send(.success)
            case false:
                self?.state.send(.fail(error: "Usuario o email incorrecto."))
            }
        }
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
