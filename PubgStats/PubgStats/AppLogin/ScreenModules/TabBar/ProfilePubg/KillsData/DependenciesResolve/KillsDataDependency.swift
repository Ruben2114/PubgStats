//
//  KillsDataDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol KillsDataDependency {
    var external: KillsDataExternalDependency { get }
    func resolve() -> KillsDataCoordinator?
    func resolve() -> KillsDataViewController
    func resolve() -> KillsDataViewModel
    func resolve() -> KillsDataUseCase
    func resolve() -> KillsDataRepository
}

extension KillsDataDependency {
    func resolve() -> KillsDataViewController {
        KillsDataViewController(dependencies: self)
    }
    func resolve() -> KillsDataViewModel {
        KillsDataViewModel(dependencies: self)
    }
    func resolve() -> KillsDataUseCase {
        KillsDataUseCaseImp(dependencies: self)
    }
    func resolve() -> KillsDataRepository {
        KillsDataRepositoryImp(dependencies: self)
    }
}
