//
//  GamesModesDataRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

struct GamesModesDataRepositoryImp: GamesModesDataRepository {
    private let dataSource: LocalDataProfileService
    init(dependencies: GamesModesDataDependency) {
        self.dataSource = dependencies.external.resolve()
    }
    func getGamesModes(for sessionUser: ProfileEntity, type: NavigationStats) -> [GamesModes]?{
        dataSource.getGameMode(for: sessionUser, type: type)
    }
}
