//
//  StatsGeneralRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol StatsGeneralRepository {
    func fetchSurvivalData(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void)
    func fetchGamesModeData(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void)
}
