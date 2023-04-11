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
}

extension SurvivalDataDependency {
    func resolve() -> SurvivalDataViewController {
        SurvivalDataViewController(dependencies: self)
    }
    func resolve() -> SurvivalDataViewModel {
        SurvivalDataViewModel(dependencies: self)
    }
}
