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
    func fetchSurvivalData(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void) {
        remoteData.getSurvivalData(account: account, completion: completion)
    }
    func fetchGamesModeData(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void) {
        remoteData.getGamesModesData(account: account, completion: completion)
    }
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO], type: NavigationStats){
        dataSource.saveSurvival(sessionUser: sessionUser, survivalData: survivalData, type: type)
    }
    func getSurvival(for sessionUser: ProfileEntity, type: NavigationStats) -> Survival?{
        dataSource.getSurvival(for: sessionUser, type: type)
    }
    func saveGamesModeData(sessionUser: ProfileEntity, gamesModeData: GamesModesDTO, type: NavigationStats){
        dataSource.saveGamesMode(sessionUser: sessionUser, gamesModeData: gamesModeData, type: type)
    }
    func getGamesModes(for sessionUser: ProfileEntity, type: NavigationStats) -> [GamesModes]?{
        dataSource.getGameMode(for: sessionUser, type: type)
    }
}
