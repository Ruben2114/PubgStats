//
//  TestProfileExternalDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats
import UIKit

final class TestProfileExternalDependencies: ProfileExternalDependencies {
    func matchesCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        fatalError()
    }
    
    func attributesHomeCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        fatalError()
    }
    
    func attributesDetailCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        fatalError()
    }
    
    func resolve() -> DataPlayerRepository {
        MockDataPlayerRepository()
    }
}
