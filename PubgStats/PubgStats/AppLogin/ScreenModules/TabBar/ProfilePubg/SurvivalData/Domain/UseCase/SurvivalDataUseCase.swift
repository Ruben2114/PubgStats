//
//  SurvivalDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol SurvivalDataUseCase {
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?
}

struct SurvivalDataUseCaseImp: SurvivalDataUseCase {
    private let survivalDataRepository: SurvivalDataRepository
    init(dependencies: SurvivalDataDependency) {
        self.survivalDataRepository = dependencies.resolve()
    }
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?{
        survivalDataRepository.getSurvival(for: sessionUser)
    }
}