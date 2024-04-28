//
//  TestMatchesExternalDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 27/4/24.
//

@testable import PubgStats

final class TestMatchesExternalDependencies: MatchesExternalDependencies {
    
    func resolve() -> DataPlayerRepository {
        MockDataPlayerRepository()
    }
}
