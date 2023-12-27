//
//  DataProfleRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import Combine

struct DataProfleRepositoryImp: DataProfleRepository {
    private let dataSource: LocalDataProfileService
    private let remoteData: RemoteService
    init(dependencies: AppDependencies) {
        self.dataSource = dependencies.resolve()
        self.remoteData = dependencies.resolve()
    }
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        if let cache = self.dataSource.getAccountProfile(player: name), !cache.name.isEmpty {
            return Just(cache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return remoteData.getPlayerData(name: name, platform: platform).map { data in
            self.dataSource.save(player: name, account: data.id ?? "", platform: platform)
            return DefaultIdAccountDataProfile(id: data.id ?? "", name: name, platform: platform)
        }.eraseToAnyPublisher()
    }
    
    func fetchSurvivalData(name: String, account: String, platform: String) -> AnyPublisher<SurvivalDataProfileRepresentable, Error> {
        if let cache = self.dataSource.getSurvival(player: name, type: .profile), cache.stats.airDropsCalled != nil {
            return Just(cache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return remoteData.getSurvivalData(account: account, platform: platform).map { data in
            self.dataSource.saveSurvival(player: name, survivalData: [data], type: .profile)
            return DefaultSurvivalDataProfile(data.data.attributes)
        }.eraseToAnyPublisher()
    }
    
    func fetchGamesModeData(name: String, account: String, platform: String) -> AnyPublisher<GamesModesDataProfileRepresentable, Error> {
        if let cache = self.dataSource.getGameMode(player: name, type: .profile), !cache.timePlayed.isEmpty {
            return Just(cache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return remoteData.getGamesModesData(account: account, platform: platform).map { data in
            self.dataSource.saveGamesMode(player: name, gamesModeData: data, type: .profile)
            return DefaultGamesModesDataProfile(data)
        }.eraseToAnyPublisher()
    }
    
    func fetchWeaponData(name: String, account: String, platform: String) -> AnyPublisher<WeaponDataProfileRepresentable, Error> {
        if let cache = self.dataSource.getDataWeaponDetail(player: name, type: .profile), !cache.weaponSummaries.isEmpty {
            return Just(cache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return remoteData.getWeaponData(account: account, platform: platform).map { data in
            self.dataSource.saveWeaponData(player: name, weaponData: data, type: .profile)
            return DefaultWeaponDataProfile(data.data)
        }.eraseToAnyPublisher()
    }
}
