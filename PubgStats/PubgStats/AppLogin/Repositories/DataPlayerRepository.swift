//
//  DataPlayerRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import Combine

public enum NavigationStats {
    case profile
    case favourite
}

public protocol DataPlayerRepository {
    func fetchPlayerData(name: String, platform: String, type: NavigationStats) -> AnyPublisher<IdAccountDataProfileRepresentable, Error>
    func fetchSurvivalData(representable: IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<SurvivalDataProfileRepresentable, Error>
    func fetchGamesModeData(representable: IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<GamesModesDataProfileRepresentable, Error>
    func fetchWeaponData(representable: IdAccountDataProfileRepresentable, type: NavigationStats,reload: Bool) -> AnyPublisher<WeaponDataProfileRepresentable, Error>
    func fetchMatchesData(id: String, platform: String) -> AnyPublisher<MatchDataProfileRepresentable, Error>
    func deletePlayerData(profile: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error>
}

struct DataPlayerRepositoryImp: DataPlayerRepository {
    private let dataSource: LocalDataProfileService
    private let remoteData: RemoteService
    init(dependencies: AppDependencies) {
        self.dataSource = dependencies.resolve()
        self.remoteData = dependencies.resolve()
    }
    
    func fetchPlayerData(name: String, platform: String, type: NavigationStats) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        if let cache = self.dataSource.getAccountProfile(player: name), !cache.name.isEmpty {
            return Just(cache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return remoteData.getPlayerData(name: name, platform: platform).map { data in
            let player = DefaultIdAccountDataProfile(id: data.id ?? "", name: name, platform: platform)
            self.dataSource.save(player: player, type: type)
            return player
        }.eraseToAnyPublisher()
    }
    
    func fetchSurvivalData(representable: IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<SurvivalDataProfileRepresentable, Error> {
        if let cache = self.dataSource.getSurvival(player: representable.name, type: type), cache.stats.airDropsCalled != nil && !reload {
            return Just(cache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return remoteData.getSurvivalData(account: representable.id, platform: representable.platform).map { data in
            let survivalData = DefaultSurvivalDataProfile(data.data.attributes)
            self.dataSource.saveSurvival(player: representable.name, survivalData: survivalData, type: type)
            return survivalData
        }.eraseToAnyPublisher()
    }
    
    func fetchGamesModeData(representable: IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<GamesModesDataProfileRepresentable, Error> {
        if let cache = self.dataSource.getGameMode(player: representable.name, type: type), !cache.timePlayed.isEmpty && !reload {
            return Just(cache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return remoteData.getGamesModesData(account: representable.id, platform: representable.platform).map { data in
            let gamesModeData = DefaultGamesModesDataProfile(data)
            self.dataSource.saveGamesMode(player: representable.name, gamesModeData: gamesModeData, type: type)
            return gamesModeData
        }.eraseToAnyPublisher()
    }
    
    func fetchWeaponData(representable: IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<WeaponDataProfileRepresentable, Error> {
        if let cache = self.dataSource.getDataWeaponDetail(player: representable.name, type: type), !cache.weaponSummaries.isEmpty && !reload {
            return Just(cache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return remoteData.getWeaponData(account: representable.id, platform: representable.platform).map { data in
            let weaponData = DefaultWeaponDataProfile(data.data)
            self.dataSource.saveWeaponData(player: representable.name, weaponData: weaponData, type: type)
            return weaponData
        }.eraseToAnyPublisher()
    }
    
    func fetchMatchesData(id: String, platform: String) -> AnyPublisher<MatchDataProfileRepresentable, Error> {
        return remoteData.getMatchesData(id: id, platform: platform).map { data in
            return DefaultMatchDataProfile(data)
        }.eraseToAnyPublisher()
    }
    
    func deletePlayerData(profile: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error> {
        return dataSource.deleteProfile(player: profile.name).eraseToAnyPublisher()
    }
}
