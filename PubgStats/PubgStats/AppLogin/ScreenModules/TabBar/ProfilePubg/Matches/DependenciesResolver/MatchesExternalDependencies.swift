//
//  MatchesExternalDependencies.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 9/4/24.
//

import UIKit

protocol MatchesExternalDependencies {
    func matchesCoordinator(navigation: UINavigationController?) -> BindableCoordinator
    func resolve() -> DataPlayerRepository
}

extension MatchesExternalDependencies {
    func matchesCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        MatchesCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
