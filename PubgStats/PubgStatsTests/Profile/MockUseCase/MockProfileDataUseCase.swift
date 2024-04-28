//
//  MockProfileDataUseCase.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 27/4/24.
//

import PubgStats
import Combine
import Foundation

final class MockProfileDataUseCase: ProfileDataUseCase {
    public var playerDataError = false
    
    func fetchPlayerDetails(_ profile: IdAccountDataProfileRepresentable, reload: Bool, type: NavigationStats) -> AnyPublisher<PlayerDetailsRepresentable, Error> {
        if playerDataError {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } else {
            return Just(MockPlayerDetails(infoSurvival: MockSurvivalDataProfile(),
                                          infoGamesModes: MockGamesModesDataProfile(),
                                          infoWeapon: MockWeaponDataProfile()))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
    }
}

struct MockPlayerDetails: PlayerDetailsRepresentable {
    var infoSurvival: SurvivalDataProfileRepresentable
    var infoGamesModes: GamesModesDataProfileRepresentable
    var infoWeapon: WeaponDataProfileRepresentable
    
    init(infoSurvival: SurvivalDataProfileRepresentable, infoGamesModes: GamesModesDataProfileRepresentable, infoWeapon: WeaponDataProfileRepresentable) {
        self.infoSurvival = infoSurvival
        self.infoGamesModes = infoGamesModes
        self.infoWeapon = infoWeapon
    }
}
