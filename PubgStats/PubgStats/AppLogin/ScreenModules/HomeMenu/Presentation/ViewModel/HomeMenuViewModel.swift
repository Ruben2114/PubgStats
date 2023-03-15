//
//  HomeMenuViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation
import Combine

final class HomeMenuViewModel {
    var state = PassthroughSubject<StateController, Never>()
    private let loginDataUseCase: LoginDataUseCase
    
    init(loginDataUseCase: LoginDataUseCase) {
        self.loginDataUseCase = loginDataUseCase
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
}
