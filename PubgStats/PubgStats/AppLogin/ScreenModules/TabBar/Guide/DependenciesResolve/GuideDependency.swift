//
//  GuideDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol GuideDependency {
    var external: GuideExternalDependency { get }
    func resolve() -> GuideViewController
    func resolve() -> GuideViewModel
    func resolve() -> GuideCoordinator
}

extension GuideDependency {
    func resolve() -> GuideViewController {
        GuideViewController(dependencies: self)
    }
    func resolve() -> GuideViewModel {
        GuideViewModel(dependencies: self)
    }
}
