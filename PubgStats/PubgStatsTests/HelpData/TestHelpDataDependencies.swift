//
//  TestHelpDataDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

@testable import PubgStats

final class TestHelpDataDependencies: HelpDataDependencies {
    var external: HelpDataExternalDependencies
    let coordinatorSpy = HelpDataCoordinatorSpy()
    
    init() {
        self.external = TestHelpDataExternalDependencies()
    }
    
    func viewModel() -> HelpDataViewModel {
        resolve()
    }
    
    func resolve() -> HelpDataCoordinator {
        coordinatorSpy
    }
}
