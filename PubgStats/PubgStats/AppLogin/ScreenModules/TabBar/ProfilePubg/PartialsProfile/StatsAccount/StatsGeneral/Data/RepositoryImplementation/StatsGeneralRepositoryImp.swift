//
//  StatsGeneralRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

struct StatsGeneralRepositoryImp: StatsGeneralRepository {
    var remoteData: RemoteService
    
    func fetchSurvivalData(account: String, completion: @escaping (Result<SurvivalDTO, Error>) -> Void) {
        remoteData.getSurvivalData(account: account, completion: completion)
    }
    
    func fetchGamesModeData(account: String, completion: @escaping (Result<GamesModesDTO, Error>) -> Void) {
        remoteData.getGamesModesData(account: account, completion: completion)
    }
}
