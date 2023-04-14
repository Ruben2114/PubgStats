//
//  SurvivalDataViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

final class SurvivalDataViewModel {
    private weak var coordinator: SurvivalDataCoordinator?
    private let dependencies: SurvivalDataDependency
    private let sessionUser: ProfileEntity
    private let survivalDataUseCase: SurvivalDataUseCase
    var content: [(String, Any)] = []
    init(dependencies: SurvivalDataDependency) {
        self.sessionUser = dependencies.external.resolve()
        self.survivalDataUseCase = dependencies.resolve()
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
    }
    
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?{
        guard let type = coordinator?.type else {return nil}
        let survivalData = survivalDataUseCase.getSurvival(for: sessionUser, type: type)
        return survivalData
    }
    func fetchDataSurvival() {
        let survivalData = getSurvival(for: sessionUser)
        if let survival = survivalData {
            let keyValues = survival.entity.attributesByName.map { ($0.key, survival.value(forKey: $0.key) ?? "") }
            content = keyValues
        }
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
