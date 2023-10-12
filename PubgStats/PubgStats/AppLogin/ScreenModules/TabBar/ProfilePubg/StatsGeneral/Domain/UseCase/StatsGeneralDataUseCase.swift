//
//  StatsGeneralDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol StatsGeneralDataUseCase {
    func executeSurvival(account: String, platform: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void)
    func executeGamesModes(account: String, platform: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void)
    func saveSurvival(survivalData: [SurvivalDTO], type: NavigationStats)
    func saveGamesModeData(gamesModeData: GamesModesDTO, type: NavigationStats)
    func getSurvival(type: NavigationStats) -> Survival?
    func getGamesModes(type: NavigationStats) -> [GamesModes]?
}

struct StatsGeneralDataUseCaseImp: StatsGeneralDataUseCase {
    private let statsGeneralRepository: StatsGeneralRepository
    init(dependencies: StatsGeneralDependency) {
        self.statsGeneralRepository = dependencies.resolve()
    }
    func executeSurvival(account: String, platform: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void){
        statsGeneralRepository.fetchSurvivalData(account: account, platform: platform, completion: completion)
    }
    func executeGamesModes(account: String, platform: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void){
        statsGeneralRepository.fetchGamesModeData(account: account, platform: platform, completion: completion)
    }
    func saveSurvival(survivalData: [SurvivalDTO], type: NavigationStats){
        statsGeneralRepository.saveSurvival(survivalData: survivalData, type: type)
    }
    func getSurvival(type: NavigationStats) -> Survival?{
        statsGeneralRepository.getSurvival(type: type)
    }
    func getGamesModes(type: NavigationStats) -> [GamesModes]?{
        statsGeneralRepository.getGamesModes(type: type)
    }
    func saveGamesModeData(gamesModeData: GamesModesDTO, type: NavigationStats){
        statsGeneralRepository.saveGamesModeData(gamesModeData: gamesModeData, type: type)
    }
}
