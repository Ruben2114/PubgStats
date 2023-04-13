//
//  FavouriteCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit
enum FavouriteTransition {
    case goStats
}
protocol FavouriteCoordinator: Coordinator {
    func performTransition(_ transition: FavouriteTransition)
}

final class FavouriteCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: FavouriteExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    public init(dependencies: FavouriteExternalDependency) {
        self.externalDependencies = dependencies
        self.navigation = dependencies.favouriteNavigationController()
    }
        
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
}
extension FavouriteCoordinatorImp: FavouriteCoordinator {
    func performTransition(_ transition: FavouriteTransition) {
        switch transition {
        case .goStats:
            let statsGeneralCoordinator = dependencies.external.statsGeneralCoordinator()
            statsGeneralCoordinator.set(navigation).set(NavigationStats.favourite).start()
            append(child: statsGeneralCoordinator)
        }
    }
}

private extension FavouriteCoordinatorImp {
    struct Dependency: FavouriteDependency {
        let external: FavouriteExternalDependency
        weak var coordinator: FavouriteCoordinator?
        
        func resolve() -> FavouriteCoordinator? {
            return coordinator
        }
    }
}
