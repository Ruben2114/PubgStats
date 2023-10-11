//
//  GamesModesDataDetailCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

protocol GamesModesDataDetailCoordinator: Coordinator {
}

final class GamesModesDataDetailCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: GamesModesDataDetailExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: GamesModesDataDetailExternalDependency, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
    
    func start() {
        let gamesModesDataDetailView: GamesModesDataDetailViewController = dependencies.resolve()
        navigation?.pushViewController(gamesModesDataDetailView, animated: false)
    }
}
extension GamesModesDataDetailCoordinatorImp: GamesModesDataDetailCoordinator {
    
}
private extension GamesModesDataDetailCoordinatorImp {
    struct Dependency: GamesModesDataDetailDependency {
        let external: GamesModesDataDetailExternalDependency
        weak var coordinator: GamesModesDataDetailCoordinator?
        
        func resolve() -> GamesModesDataDetailCoordinator? {
            return coordinator
        }
    }
}
