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
protocol StatsGeneralCoordinator: BindableCoordinator {
    func performTransition(_ transition: StatsGeneralTransition)
}

final class StatsGeneralCoordinatorImp: BindableCoordinator {
    var dataBinding: DataBinding
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: StatsGeneralExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: StatsGeneralExternalDependency) {
        self.externalDependencies = dependencies
        self.dataBinding = DataBindingObject()
    }
    
    func start() {
        let statsGeneralView: StatsGeneralViewController = dependencies.resolve()
        navigation = dataBinding.get()
        navigation?.pushViewController(statsGeneralView, animated: false)
    }
}
extension StatsGeneralCoordinatorImp: StatsGeneralCoordinator {
    func performTransition(_ transition: StatsGeneralTransition) {
        switch transition {
        case .goKillsData:
            guard let navigationController = navigation else {return}
            let killsDataCoordinator = dependencies.external.killsDataCoordinator(navigation: navigationController)
            killsDataCoordinator.start()
            append(child: killsDataCoordinator)
        case .goWeapons:
            let weaponDataCoordinator = dependencies.external.weaponDataCoordinator()
            weaponDataCoordinator.start()
            append(child: weaponDataCoordinator)
        case .goSurvival:
            let survivalDataCoordinator = dependencies.external.survivalDataCoordinator()
            survivalDataCoordinator.start()
            append(child: survivalDataCoordinator)
        case .goGamesModes:
            let gamesModeDataCoordinator = dependencies.external.gamesModesDataCoordinator()
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
