//
//  DataProfleRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import Combine

public protocol DataProfleRepository {
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error>
    func fetchSurvivalData(name: String, account: String, platform: String) -> AnyPublisher<SurvivalDataProfileRepresentable, Error>
    func fetchGamesModeData(name: String, account: String, platform: String) -> AnyPublisher<GamesModesDataProfileRepresentable, Error>
    func fetchWeaponData(name: String, account: String, platform: String) -> AnyPublisher<WeaponDataProfileRepresentable, Error>
}
