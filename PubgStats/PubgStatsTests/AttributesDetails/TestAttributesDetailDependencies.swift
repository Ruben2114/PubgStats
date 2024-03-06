//
//  TestAttributesDetailDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 21/2/24.
//

@testable import PubgStats

final class TestAttributesDetailDependencies: AttributesDetailDependencies {
    var external: AttributesDetailExternalDependencies
    let coordinatorSpy = AttributesDetailCoordinatorSpy()
    
    init() {
        self.external = TestAttributesDetailExternalDependencies()
    }
    
    func viewModel() -> AttributesDetailViewModel {
        resolve()
    }
    
    func resolve() -> DataBinding {
        DataBindingObject()
    }
    
    func resolve() -> AttributesDetailCoordinator {
        coordinatorSpy
    }
}
