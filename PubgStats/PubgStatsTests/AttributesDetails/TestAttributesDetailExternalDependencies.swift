//
//  TestAttributesDetailExternalDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 21/2/24.
//

@testable import PubgStats
import UIKit

final class TestAttributesDetailExternalDependencies: AttributesDetailExternalDependencies {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func attributesDetailCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        fatalError()
    }
}
