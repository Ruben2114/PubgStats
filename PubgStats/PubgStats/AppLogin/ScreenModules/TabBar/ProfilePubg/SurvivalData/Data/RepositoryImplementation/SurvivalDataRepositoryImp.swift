//
//  SurvivalDataRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

struct SurvivalDataRepositoryImp: SurvivalDataRepository {
    private let dataSource: LocalDataProfileService
    
    init(dependencies: SurvivalDataDependency) {
        self.dataSource = dependencies.external.resolve()
    }
    
    func getSurvival(type: NavigationStats) -> Survival? {
        return nil
    }
}


