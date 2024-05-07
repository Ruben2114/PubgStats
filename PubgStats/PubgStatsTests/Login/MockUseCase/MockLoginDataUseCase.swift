//
//  MockLoginDataUseCase.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 27/4/24.
//

import PubgStats
import Combine
import Foundation

final class MockLoginDataUseCase: LoginDataUseCase {
    public var playerDataError = false
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        if playerDataError {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } else {
            return Just(MockIdAccountDataProfile(id: "1111", name: name, platform: platform)).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
