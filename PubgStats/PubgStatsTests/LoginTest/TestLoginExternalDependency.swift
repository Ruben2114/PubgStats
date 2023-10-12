//
//  TestLoginExternalDependency.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
@testable import PubgStats
import UIKit

final class TestLoginExternalDependency: LoginExternalDependency {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func loginNavigationController() -> UINavigationController {
        navigationController
    }
    
    func resolve() -> DataProfleRepository {
        MockDataProfleRepository()
    }
}
