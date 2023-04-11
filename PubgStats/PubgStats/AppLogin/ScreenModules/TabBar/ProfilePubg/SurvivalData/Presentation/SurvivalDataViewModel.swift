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
    var content: [(String, Any)] = []
    init(dependencies: SurvivalDataDependency) {
        self.sessionUser = dependencies.external.resolve()
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
    }
    //TODO: empujar esto a use case
    let localData = LocalDataProfileServiceImp()
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?{
        localData.getSurvival(for: sessionUser)
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
