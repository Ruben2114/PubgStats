//
//  TestAttributesHomeDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats

final class TestAttributesHomeDependencies: AttributesHomeDependencies {
    var external: AttributesHomeExternalDependencies
    let coordinatorSpy = AttributesHomeCoordinatorSpy()
    
    init() {
        self.external = TestAttributesHomeExternalDependencies()
    }
    
    func viewModel() -> AttributesHomeViewModel {
        resolve()
    }
    
    func resolve() -> DataBinding {
        DataBindingObject()
    }
    
    func resolve() -> AttributesHomeCoordinator {
        coordinatorSpy
    }
}
