//
//  SurvivalDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol SurvivalDataUseCase {
    func getSurvival(type: NavigationStats) -> Survival?
}

struct SurvivalDataUseCaseImp: SurvivalDataUseCase {
    private let survivalDataRepository: SurvivalDataRepository
    init(dependencies: SurvivalDataDependency) {
        self.survivalDataRepository = dependencies.resolve()
    }
    func getSurvival(type: NavigationStats) -> Survival?{
        survivalDataRepository.getSurvival(type: type)
    }
}
