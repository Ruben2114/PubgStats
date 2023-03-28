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
    func resolve() -> StatsGeneralDataUseCase
}

extension StatsGeneralDependency {
    func resolve() -> StatsGeneralViewController {
        StatsGeneralViewController(dependencies: self)
    }
    func resolve() -> StatsGeneralViewModel {
        StatsGeneralViewModel(dependencies: self)
    }
    func resolve() -> StatsGeneralDataUseCase {
        let remoteData = AppContainerImp().remoteDataService
        let statsGeneralRepository = StatsGeneralRepositoryImp(remoteData: remoteData)
        let statsGeneralDataUseCase = StatsGeneralDataUseCaseImp(statsGeneralRepository: statsGeneralRepository)
        return statsGeneralDataUseCase
    }
}
