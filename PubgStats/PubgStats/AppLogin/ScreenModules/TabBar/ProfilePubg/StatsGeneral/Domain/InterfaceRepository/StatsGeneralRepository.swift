//
//  StatsGeneralRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol StatsGeneralRepository {
    func fetchSurvivalData(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void)
    func fetchGamesModeData(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void)
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO], type: NavigationStats)
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?
    func saveGamesModeData(sessionUser: ProfileEntity, gamesModeData: [GamesModesDTO], type: NavigationStats)
    func getGamesModes(for sessionUser: ProfileEntity) -> [GamesModes]?
}
