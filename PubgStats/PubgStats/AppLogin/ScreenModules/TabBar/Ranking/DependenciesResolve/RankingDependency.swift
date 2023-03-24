//
//  RankingDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol RankingDependency {
    var external: RankingExternalDependency { get }
    func resolve() -> RankingViewController
    func resolve() -> RankingCoordinator
}

extension RankingDependency {
    func resolve() -> RankingViewController {
        RankingViewController(dependencies: self)
    }
}
