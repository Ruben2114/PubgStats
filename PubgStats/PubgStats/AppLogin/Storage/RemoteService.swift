//
//  RemoteService.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import Foundation
import Combine

protocol RemoteService {
    func getPlayerData(name: String, platform: String) -> AnyPublisher<PubgPlayerDTO, Error>
    func getSurvivalData(account: String, platform: String) -> AnyPublisher<SurvivalDTO, Error>
    func getGamesModesData(account: String, platform: String) -> AnyPublisher<GamesModesDTO, Error>
    func getWeaponData(account: String, platform: String) -> AnyPublisher<WeaponDTO, Error>
    func getMatchesData(id: String, platform: String) -> AnyPublisher<MatchDTO, Error>
}

struct RemoteServiceImp: RemoteService {
    private let apiService = ApiClientServiceImp()
    
    func getPlayerData(name: String, platform: String) -> AnyPublisher<PubgPlayerDTO, Error> {
        guard let url = URL(string: ApisUrl.generalData(name: name, platform: platform).urlString) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher()}
        return apiService.dataPlayer(url: url).eraseToAnyPublisher()
    }
    
    func getSurvivalData(account: String, platform: String) -> AnyPublisher<SurvivalDTO, Error> {
        guard let url = URL(string: ApisUrl.survivalData(id: account, platform: platform).urlString) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher()}
        return apiService.dataPlayer(url: url).eraseToAnyPublisher()
    }
    
    func getGamesModesData(account: String, platform: String) -> AnyPublisher<GamesModesDTO, Error> {
        guard let url = URL(string: ApisUrl.gameModeData(id: account, platform: platform).urlString) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher()}
        return apiService.dataPlayer(url: url).eraseToAnyPublisher()
    }
    
    func getWeaponData(account: String, platform: String) -> AnyPublisher<WeaponDTO, Error> {
        guard let url = URL(string: ApisUrl.weaponData(id: account, platform: platform).urlString) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher()}
        return apiService.dataPlayer(url: url).eraseToAnyPublisher()
    }
    
    func getMatchesData(id: String, platform: String) -> AnyPublisher<MatchDTO, Error> {
        guard let url = URL(string: ApisUrl.matchesData(id: id, platform: platform).urlString) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher()}
        return apiService.dataPlayer(url: url).eraseToAnyPublisher()
    }
}

