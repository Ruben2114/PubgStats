//
//  TestSettingsDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

@testable import PubgStats

final class TestSettingsDependencies: SettingsDependencies {
    var external: SettingsExternalDependencies
    let coordinatorSpy = SettingsCoordinatorSpy()
    let mockSettingsDataUseCase = MockSettingsDataUseCase()
    var shouldUseMockSettingsDataUseCase = false
    var deleteProfileError = false
    
    init() {
        self.external = TestSettingsExternalDependencies()
    }
    
    func viewModel() -> SettingsViewModel {
        resolve()
    }
    
    func resolve() -> DataBinding {
        DataBindingObject()
    }
    
    func resolve() -> SettingsCoordinator {
        coordinatorSpy
    }
    
    func resolve() -> SettingsDataUseCase {
        if shouldUseMockSettingsDataUseCase {
            mockSettingsDataUseCase.deleteProfileError = deleteProfileError
            return mockSettingsDataUseCase
        } else {
            return SettingsDataUseCaseImp(dependencies: self)
        }
    }
}
