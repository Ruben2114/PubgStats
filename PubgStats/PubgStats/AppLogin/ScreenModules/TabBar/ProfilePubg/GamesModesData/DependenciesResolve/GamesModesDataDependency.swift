//
//  GamesModesDataDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol GamesModesDataDependency {
    var external: GamesModesDataExternalDependency { get }
    func resolve() -> GamesModesDataCoordinator?
    func resolve() -> GamesModesDataViewController
    func resolve() -> GamesModesDataViewModel
    func resolve() -> GamesModesDataUseCase
    func resolve() -> GamesModesDataRepository
}

extension GamesModesDataDependency {
    func resolve() -> GamesModesDataViewController {
        GamesModesDataViewController(dependencies: self)
    }
    func resolve() -> GamesModesDataViewModel {
        GamesModesDataViewModel(dependencies: self)
    }
    func resolve() -> GamesModesDataUseCase {
        GamesModesDataUseCaseImp(dependencies: self)
    }
    func resolve() -> GamesModesDataRepository {
        GamesModesDataRepositoryImp(dependencies: self)
    }
}
