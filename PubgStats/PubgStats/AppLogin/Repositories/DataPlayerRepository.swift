//
//  DataPlayerRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import Combine

public protocol DataPlayerRepository {
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error>
    func fetchSurvivalData(representable: IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<SurvivalDataProfileRepresentable, Error>
    func fetchGamesModeData(representable: IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<GamesModesDataProfileRepresentable, Error>
    func fetchWeaponData(representable: IdAccountDataProfileRepresentable, type: NavigationStats,reload: Bool) -> AnyPublisher<WeaponDataProfileRepresentable, Error>
}
