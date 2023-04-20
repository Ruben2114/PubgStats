//
//  RankingExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol RankingExternalDependency {
    func resolve() -> AppDependencies
    func rankingCoordinator() -> Coordinator
    func rankingNavigationController() -> UINavigationController
}
extension RankingExternalDependency {
    func rankingCoordinator() -> Coordinator {
        RankingCoordinatorImp(dependencies: self)
    }
}
