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
    let mockMatchesDataUseCase = MockMatchesDataUseCase()
    var shouldUseMockMatchesDataUseCase = false
    var matchesDataError = false
    
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
    
    func resolve() -> MatchesDataUseCase {
        if shouldUseMockMatchesDataUseCase {
            mockMatchesDataUseCase.matchesDataError = matchesDataError
            return mockMatchesDataUseCase
        } else {
            return MatchesDataUseCaseImp(dependencies: self)
        }
    }
}
