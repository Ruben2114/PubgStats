//
//  TestLoginDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
@testable import PubgStats

final class TestLoginDependencies: LoginDependencies {
    var external: LoginExternalDependencies
    let coordinatorSpy = LoginCoordinatorSpy()
    let mockLoginDataUseCase = MockLoginDataUseCase()
    var shouldUseMockLoginDataUseCase = false
    var playerDataError = false
    
    init() {
        self.external = TestLoginExternalDependencies()
    }
    
    func resolve() -> LoginCoordinator {
        coordinatorSpy
    }
    
    func viewModel() -> LoginViewModel {
        resolve()
    }
    
    func resolve() -> LoginDataUseCase {
        if shouldUseMockLoginDataUseCase {
            mockLoginDataUseCase.playerDataError = playerDataError
            return mockLoginDataUseCase
        } else {
            return LoginDataUseCaseImp(dependencies: self)
        }
    }
}
