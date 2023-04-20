//
//  StatsGeneralDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol StatsGeneralDataUseCase {
    func executeSurvival(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void)
    func executeGamesModes(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void)
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO], type: NavigationStats)
    func saveGamesModeData(sessionUser: ProfileEntity, gamesModeData: GamesModesDTO, type: NavigationStats)
    func getSurvival(for sessionUser: ProfileEntity, type: NavigationStats) -> Survival?
    func getGamesModes(for sessionUser: ProfileEntity, type: NavigationStats) -> [GamesModes]?
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
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO], type: NavigationStats){
        statsGeneralRepository.saveSurvival(sessionUser: sessionUser, survivalData: survivalData, type: type)
    }
    func getSurvival(for sessionUser: ProfileEntity, type: NavigationStats) -> Survival?{
        statsGeneralRepository.getSurvival(for: sessionUser, type: type)
    }
    func getGamesModes(for sessionUser: ProfileEntity, type: NavigationStats) -> [GamesModes]?{
        statsGeneralRepository.getGamesModes(for: sessionUser, type: type)
    }
    
    func saveGamesModeData(sessionUser: ProfileEntity, gamesModeData: GamesModesDTO, type: NavigationStats){
        statsGeneralRepository.saveGamesModeData(sessionUser: sessionUser, gamesModeData: gamesModeData, type: type)
    }
}
