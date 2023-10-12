//
//  StatsGeneralRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol StatsGeneralRepository {
    func fetchSurvivalData(account: String, platform: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void)
    func fetchGamesModeData(account: String, platform: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void)
    func saveSurvival(survivalData: [SurvivalDTO], type: NavigationStats)
    func getSurvival(type: NavigationStats) -> Survival?
    func saveGamesModeData(gamesModeData: GamesModesDTO, type: NavigationStats)
    func getGamesModes(type: NavigationStats) -> [GamesModes]?
}
