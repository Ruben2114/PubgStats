//
//  DataProfleRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import Combine

public protocol DataProfileRepository {
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error>
    func fetchSurvivalData(representable: IdAccountDataProfileRepresentable) -> AnyPublisher<SurvivalDataProfileRepresentable, Error>
    func fetchGamesModeData(representable: IdAccountDataProfileRepresentable) -> AnyPublisher<GamesModesDataProfileRepresentable, Error>
    func fetchWeaponData(representable: IdAccountDataProfileRepresentable) -> AnyPublisher<WeaponDataProfileRepresentable, Error>
}
