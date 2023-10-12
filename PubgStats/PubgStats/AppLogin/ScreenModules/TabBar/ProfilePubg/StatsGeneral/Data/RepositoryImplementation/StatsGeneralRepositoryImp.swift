//
//  StatsGeneralRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

struct StatsGeneralRepositoryImp: StatsGeneralRepository {
    private let remoteData: RemoteService
    private let dataSource: LocalDataProfileService
    init(dependencies: StatsGeneralDependency) {
        self.remoteData = dependencies.external.resolve()
        self.dataSource = dependencies.external.resolve()
    }
    func fetchSurvivalData(account: String, platform: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void) {
    }
    func fetchGamesModeData(account: String, platform: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void) {
    }
    func saveSurvival(survivalData: [SurvivalDTO], type: NavigationStats){
    }
    func getSurvival(type: NavigationStats) -> Survival?{
        return nil
    }
    func saveGamesModeData(gamesModeData: GamesModesDTO, type: NavigationStats){
    }
    func getGamesModes(type: NavigationStats) -> [GamesModes]?{
        return []
    }
}
