//
//  StatsGeneralDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol StatsGeneralDependency {
    var external: StatsGeneralExternalDependency { get }
    func resolve() -> StatsGeneralCoordinator?
    func resolve() -> StatsGeneralViewController
    func resolve() -> StatsGeneralViewModel
}

extension StatsGeneralDependency {
    func resolve() -> StatsGeneralViewController {
        StatsGeneralViewController(dependencies: self)
    }
    func resolve() -> StatsGeneralViewModel {
        StatsGeneralViewModel(dependencies: self)
    }
}
