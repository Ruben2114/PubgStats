//
//  GamesModesDataDetailDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol GamesModesDataDetailDependency {
    var external: GamesModesDataDetailExternalDependency { get }
    func resolve() -> GamesModesDataDetailCoordinator?
    func resolve() -> GamesModesDataDetailViewController
    func resolve() -> GamesModesDataDetailViewModel
}

extension GamesModesDataDetailDependency {
    func resolve() -> GamesModesDataDetailViewController {
        GamesModesDataDetailViewController(dependencies: self)
    }
    func resolve() -> GamesModesDataDetailViewModel {
        GamesModesDataDetailViewModel(dependencies: self)
    }
}
