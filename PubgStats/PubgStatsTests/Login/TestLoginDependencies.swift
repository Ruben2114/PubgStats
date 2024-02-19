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
    
    init() {
        self.external = TestLoginExternalDependencies()
    }
    
    func resolve() -> LoginCoordinator {
        coordinatorSpy
    }
    
    func viewModel() -> LoginViewModel {
        resolve()
    }
}
