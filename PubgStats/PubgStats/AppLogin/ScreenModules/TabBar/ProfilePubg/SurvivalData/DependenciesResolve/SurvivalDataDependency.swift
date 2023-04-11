//
//  SurvivalDataDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

protocol SurvivalDataDependency {
    var external: SurvivalDataExternalDependency { get }
    func resolve() -> SurvivalDataCoordinator?
    func resolve() -> SurvivalDataViewController
    func resolve() -> SurvivalDataViewModel
    func resolve() -> SurvivalDataUseCase
    func resolve() -> SurvivalDataRepository
}

extension SurvivalDataDependency {
    func resolve() -> SurvivalDataViewController {
        SurvivalDataViewController(dependencies: self)
    }
    func resolve() -> SurvivalDataViewModel {
        SurvivalDataViewModel(dependencies: self)
    }
    func resolve() -> SurvivalDataUseCase {
        SurvivalDataUseCaseImp(dependencies: self)
    }
    func resolve() -> SurvivalDataRepository {
        SurvivalDataRepositoryImp(dependencies: self)
    }
}
