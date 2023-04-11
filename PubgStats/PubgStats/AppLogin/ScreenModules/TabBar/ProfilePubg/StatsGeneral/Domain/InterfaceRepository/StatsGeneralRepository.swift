//
//  StatsGeneralRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol StatsGeneralRepository {
    func fetchSurvivalData(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void)
    func fetchGamesModeData(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void)
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO])
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?
    func saveGamesModeData(sessionUser: ProfileEntity, gamesModeData: [GamesModesDTO])
    func getGamesModes(for sessionUser: ProfileEntity) -> [GamesModes]?
}
