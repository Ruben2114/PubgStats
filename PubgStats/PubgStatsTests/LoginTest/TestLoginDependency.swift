//
//  TestLoginDependency.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
@testable import PubgStats

final class TestLoginDependency: LoginDependency {
    var external: LoginExternalDependency
    let coordinatorSpy = LoginCoordinatorSpy()
    
    init() {
        self.external = TestLoginExternalDependency()
    }
    
    func resolve() -> LoginCoordinator {
        coordinatorSpy
    }
    
    func viewModel() -> LoginViewModel {
        resolve()
    }
}
