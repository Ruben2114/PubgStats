//
//  MockMatchesDataUseCase.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

import PubgStats
import Combine
import Foundation

final class MockMatchesDataUseCase: MatchesDataUseCase {
    public var matchesDataError = false
    
    func fetchMatches(_ id: [String], platform: String) -> AnyPublisher<[MatchDataProfileRepresentable], Error> {
        if matchesDataError {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } else {
            return Just([MockMatchDataProfile()])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
    }
}
