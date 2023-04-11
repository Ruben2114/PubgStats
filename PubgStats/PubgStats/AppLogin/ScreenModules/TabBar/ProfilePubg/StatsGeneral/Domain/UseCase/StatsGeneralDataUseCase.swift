//
//  StatsGeneralDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol StatsGeneralDataUseCase {
    func executeSurvival(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void)
    func executeGamesModes(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void)
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO])
    func saveGamesModeData(sessionUser: ProfileEntity, gamesModeData: [GamesModesDTO])
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?
    func getGamesModes(for sessionUser: ProfileEntity) -> [GamesModes]?
}

struct StatsGeneralDataUseCaseImp: StatsGeneralDataUseCase {
    private let statsGeneralRepository: StatsGeneralRepository
    init(dependencies: StatsGeneralDependency) {
        self.statsGeneralRepository = dependencies.resolve()
    }
    func executeSurvival(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void){
        statsGeneralRepository.fetchSurvivalData(account: account, completion: completion)
    }
    func executeGamesModes(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void){
        statsGeneralRepository.fetchGamesModeData(account: account, completion: completion)
    }
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO]){
        statsGeneralRepository.saveSurvival(sessionUser: sessionUser, survivalData: survivalData)
    }
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?{
        statsGeneralRepository.getSurvival(for: sessionUser)
    }
    func getGamesModes(for sessionUser: ProfileEntity) -> [GamesModes]?{
        statsGeneralRepository.getGamesModes(for: sessionUser)
    }
    
    func saveGamesModeData(sessionUser: ProfileEntity, gamesModeData: [GamesModesDTO]){
        statsGeneralRepository.saveGamesModeData(sessionUser: sessionUser, gamesModeData: gamesModeData)
    }
}
