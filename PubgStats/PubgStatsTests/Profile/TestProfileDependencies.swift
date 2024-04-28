//
//  TestProfileDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats

final class TestProfileDependencies: ProfileDependencies {
    var external: ProfileExternalDependencies
    let coordinatorSpy = ProfileCoordinatorSpy()
    let mockProfileDataUseCase = MockProfileDataUseCase()
    var shouldUseMockProfileDataUseCase = false
    var playerDataError = false
    
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
    
    func resolve() -> ProfileDataUseCase {
        if shouldUseMockProfileDataUseCase {
            mockProfileDataUseCase.playerDataError = playerDataError
            return mockProfileDataUseCase
        } else {
            return ProfileDataUseCaseImp(dependencies: self)
        }
    }
}
