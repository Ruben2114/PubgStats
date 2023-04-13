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
}

final class StatsGeneralCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: StatsGeneralExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: StatsGeneralExternalDependency, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
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
            let killsDataCoordinator = dependencies.external.killsDataCoordinator()
            killsDataCoordinator.start()
            append(child: killsDataCoordinator)
        case .goWeapons:
            let weaponDataCoordinator = dependencies.external.weaponDataCoordinator()
            weaponDataCoordinator.start()
            append(child: weaponDataCoordinator)
        case .goSurvival:
            print("goSurvival")
        case .goGamesModes:
            print("goGamesModes")
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