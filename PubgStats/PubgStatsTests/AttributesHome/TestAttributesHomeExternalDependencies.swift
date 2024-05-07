//
//  TestAttributesHomeExternalDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats
import UIKit

final class TestAttributesHomeExternalDependencies: AttributesHomeExternalDependencies {
    func attributesDetailCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        fatalError()
    }
}
