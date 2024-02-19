//
//  TestProfileExternalDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats
import UIKit

final class TestProfileExternalDependencies: ProfileExternalDependencies {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func attributesHomeCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        fatalError()
    }
    
    func attributesDetailCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        fatalError()
    }
    
    func resolve() -> DataProfileRepository {
        MockDataProfleRepository()
    }
}
