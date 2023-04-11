//
//  GamesModesDataCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit
enum GamesModesTransition {
    case goGameMode
}
protocol GamesModesDataCoordinator: Coordinator {
    func performTransition(_ transition: GamesModesTransition)
}

final class GamesModesDataCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: GamesModesDataExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: GamesModesDataExternalDependency, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
    
    func start() {
        let gamesModeDataView: GamesModesDataViewController = dependencies.resolve()
        navigation?.pushViewController(gamesModeDataView, animated: false)
    }
}
extension GamesModesDataCoordinatorImp: GamesModesDataCoordinator {
    func performTransition(_ transition: GamesModesTransition) {
        switch transition{
        case .goGameMode:
            let gamesModesDataDetailCoordinator = dependencies.external.gamesModesDataDetailCoordinator()
            gamesModesDataDetailCoordinator.start()
            append(child: gamesModesDataDetailCoordinator)
        }
    }
}

private extension GamesModesDataCoordinatorImp {
    struct Dependency: GamesModesDataDependency {
        let external: GamesModesDataExternalDependency
        weak var coordinator: GamesModesDataCoordinator?
        
        func resolve() -> GamesModesDataCoordinator? {
            return coordinator
        }
    }
}
