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
        if let cache = self.dataSource.getAccountProfile(player: name), cache.id != nil{
            return Just(cache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return remoteData.getPlayerData(name: name, platform: platform).map { data in
            self.dataSource.save(player: name, account: data.id ?? "", platform: platform)
            return DefaultIdAccountDataProfileRepresentable(id: data.id, name: data.name)
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
        return remoteData.getGamesModesData(account: account, platform: platform).map { data in
            self.dataSource.saveGamesMode(player: name, gamesModeData: data, type: .profile)
            return DefaultGamesModesDataProfileRepresentable(data)
        }.eraseToAnyPublisher()
    }

}
