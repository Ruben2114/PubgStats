//
//  InfoAppDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

protocol InfoAppDependency {
    var external: InfoAppExternalDependency { get }
    func resolve() -> InfoAppCoordinator?
    func resolve() -> InfoAppViewController
    func resolve() -> InfoAppViewModel
}

extension InfoAppDependency {
    func resolve() -> InfoAppViewController {
        InfoAppViewController(dependencies: self)
    }
    func resolve() -> InfoAppViewModel {
        InfoAppViewModel(dependencies: self)
    }
}
