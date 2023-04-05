//
//  StatsGeneralDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol StatsGeneralDataUseCase {
    func executeSurvival(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void)
    func executeGamesModes(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void)
}

struct StatsGeneralDataUseCaseImp: StatsGeneralDataUseCase {
    private(set) var statsGeneralRepository: StatsGeneralRepository

    func executeSurvival(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void){
        statsGeneralRepository.fetchSurvivalData(account: account, completion: completion)
    }
    func executeGamesModes(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void){
        statsGeneralRepository.fetchGamesModeData(account: account, completion: completion)
    }
}
