//
//  TestSettingsExternalDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

@testable import PubgStats
import UIKit

final class TestSettingsExternalDependencies: SettingsExternalDependencies {
    func helpDataCoordinator(navigation: UINavigationController?) -> Coordinator {
        fatalError()
    }
    
    func resolve() -> DataPlayerRepository {
        MockDataPlayerRepository()
    }
}
