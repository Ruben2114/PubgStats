//
//  TestLoginExternalDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
@testable import PubgStats
import UIKit

final class TestLoginExternalDependencies: LoginExternalDependencies {
    
    func resolve() -> DataPlayerRepository {
        MockDataPlayerRepository()
    }
}
