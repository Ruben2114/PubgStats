//
//  StatsGeneralCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit
enum StatsGeneralTransition {
    case goKillsData
    case goWeapons
    case goSurvival
    case goGamesModes
}
protocol StatsGeneralCoordinator: Coordinator {
    func performTransition(_ transition: StatsGeneralTransition)
    var type: NavigationStats {get}
}

final class StatsGeneralCoordinatorImp: Coordinator {
    var type: NavigationStats
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: StatsGeneralExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: StatsGeneralExternalDependency, navigation: UINavigationController, type: NavigationStats) {
        self.externalDependencies = dependencies
        self.type = type
        self.navigation = navigation
    }
    
    func start() {
        let statsGeneralView: StatsGeneralViewController = dependencies.resolve()
        navigation?.pushViewController(statsGeneralView, animated: false)
    }
}
extension StatsGeneralCoordinatorImp: StatsGeneralCoordinator {
    func performTransition(_ transition: StatsGeneralTransition) {
        switch transition {
        case .goKillsData:
            guard let navigationController = navigation else {return}
            let killsDataCoordinator = dependencies.external.killsDataCoordinator(navigation: navigationController, type: type)
            killsDataCoordinator.start()
            append(child: killsDataCoordinator)
        case .goWeapons:
            guard let navigationController = navigation else {return}
            let weaponDataCoordinator = dependencies.external.weaponDataCoordinator(navigation: navigationController, type: type)
            weaponDataCoordinator.start()
            append(child: weaponDataCoordinator)
        case .goSurvival:
            guard let navigationController = navigation else {return}
            let survivalDataCoordinator = dependencies.external.survivalDataCoordinator(navigation: navigationController, type: type)
            survivalDataCoordinator.start()
            append(child: survivalDataCoordinator)
        case .goGamesModes:
            guard let navigationController = navigation else {return}
            let gamesModeDataCoordinator = dependencies.external.gamesModesDataCoordinator(navigation: navigationController, type: type)
            gamesModeDataCoordinator.start()
            append(child: gamesModeDataCoordinator)
        }
    }
}

private extension StatsGeneralCoordinatorImp {
    struct Dependency: StatsGeneralDependency {
        let external: StatsGeneralExternalDependency
        weak var coordinator: StatsGeneralCoordinator?
        
        func resolve() -> StatsGeneralCoordinator? {
            return coordinator
        }
    }
}
