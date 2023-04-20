//
//  RankingCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol RankingCoordinator: Coordinator {
    
}
final class RankingCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: RankingExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    public init(dependencies: RankingExternalDependency) {
        self.externalDependencies = dependencies
        self.navigation = dependencies.rankingNavigationController()
    }
        
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
}
extension RankingCoordinatorImp: RankingCoordinator {}

private extension RankingCoordinatorImp {
    struct Dependency: RankingDependency {
        let external: RankingExternalDependency
        weak var coordinator: RankingCoordinator?
        
        func resolve() -> RankingCoordinator? {
            return coordinator
        }
    }
}
