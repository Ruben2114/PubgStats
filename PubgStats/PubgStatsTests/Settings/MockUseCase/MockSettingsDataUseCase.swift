//
//  MockSettingsDataUseCase.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

import PubgStats
import Combine
import Foundation

final class MockSettingsDataUseCase: SettingsDataUseCase {
    public var deleteProfileError = false
    
    func deleteProfile(profile: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error> {
        if deleteProfileError {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } else {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
