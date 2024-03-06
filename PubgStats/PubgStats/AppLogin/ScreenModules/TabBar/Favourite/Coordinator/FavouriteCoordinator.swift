//
//  FavouriteCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

public protocol FavouriteCoordinator: Coordinator {
    func goToProfile(data: IdAccountDataProfileRepresentable?)
}

final class FavouriteCoordinatorImp: FavouriteCoordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: FavouriteExternalDependencies
    private lazy var dependencies: Dependency = {
        Dependency(dependencies: externalDependencies,
                   coordinator: self)
    }()
    
    public init(dependencies: FavouriteExternalDependencies, navigation: UINavigationController?) {
        self.externalDependencies = dependencies
        self.navigation = navigation
    }
}
extension FavouriteCoordinatorImp {
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func goToProfile(data: IdAccountDataProfileRepresentable?) {
        let coordinator = dependencies.external.profileCoordinator(navigation: navigation)
        let type: NavigationStats = .profile
        coordinator
            .set(type)
            .set(data)
            .start()
        append(child: coordinator)
    }
}

private extension FavouriteCoordinatorImp {
    struct Dependency: FavouriteDependencies {
        let dependencies: FavouriteExternalDependencies
        unowned let coordinator: FavouriteCoordinator
        
        var external: FavouriteExternalDependencies {
            return dependencies
        }
        
        func resolve() -> FavouriteCoordinator {
            return coordinator
        }
    }
}
