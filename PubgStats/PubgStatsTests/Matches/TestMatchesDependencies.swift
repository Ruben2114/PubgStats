//
//  TestMatchesDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 27/4/24.
//

@testable import PubgStats

final class TestMatchesDependencies: MatchesDependencies {
    var external: MatchesExternalDependencies
    let coordinatorSpy = MatchesCoordinatorSpy()
    
    init() {
        self.external = TestMatchesExternalDependencies()
    }
    
    func viewModel() -> MatchesViewModel {
        resolve()
    }
    
    func resolve() -> DataBinding {
        DataBindingObject()
    }
    
    func resolve() -> MatchesCoordinator {
        coordinatorSpy
    }
}
