//
//  KillsDataRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

struct KillsDataRepositoryImp: KillsDataRepository {
    private let dataSource: LocalDataProfileService
    init(dependencies: KillsDataDependency) {
        self.dataSource = dependencies.external.resolve()
    }
    func getGamesModes(type: NavigationStats) -> [GamesModes]?{
        return []
    }
}
