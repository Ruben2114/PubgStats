//
//  TestProfileDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats

final class TestProfileDependencies: ProfileDependencies {
    //TODO: falta el usecase
    var external: ProfileExternalDependencies
    let coordinatorSpy = ProfileCoordinatorSpy()
    
    init() {
        self.external = TestProfileExternalDependencies()
    }
    
    func resolve() -> ProfileCoordinator {
        coordinatorSpy
    }
    
    func viewModel() -> ProfileViewModel {
        resolve()
    }
    
    func resolve() -> DataBinding {
        DataBindingObject()
    }
}
