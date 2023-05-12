//
//  RemoteService.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import Foundation

protocol RemoteService {
    func getPlayerData(name: String, platform: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void)
    func getSurvivalData(account: String, platform: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void)
    func getGamesModesData(account: String, platform: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void)
    func getWeaponData(account: String, platform: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void)
}

struct RemoteServiceImp: RemoteService {
    private let apiService = ApiClientServiceImp()
    
    func getPlayerData(name: String, platform: String, completion: @escaping (Result<PubgPlayerDTO, Error>) -> Void) {
        guard let url = URL(string: ApisUrl.generalData(name: name, platform: platform).urlString) else { return }
        apiService.dataPlayer(url: url, completion: completion)
    }
    func getSurvivalData(account: String, platform: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void) {
        guard let url = URL(string: ApisUrl.survivalData(id: account, platform: platform).urlString) else { return }
        apiService.dataPlayer(url: url, completion: completion)
    }
    func getGamesModesData(account: String, platform: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void) {
        guard let url = URL(string: ApisUrl.gameModeData(id: account, platform: platform).urlString) else { return }
        apiService.dataPlayer(url: url, completion: completion)
    }
    func getWeaponData(account: String, platform: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void) {
        guard let url = URL(string: ApisUrl.weaponData(id: account, platform: platform).urlString) else { return }
        apiService.dataPlayer(url: url, completion: completion)
    }
}
