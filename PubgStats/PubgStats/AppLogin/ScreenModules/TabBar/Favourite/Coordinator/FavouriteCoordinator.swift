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
            guard let navigationController = navigation else {return}
            let statsGeneralCoordinator = dependencies.external.statsGeneralCoordinator(navigation: navigationController, type: .favourite)
            statsGeneralCoordinator.start()
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
