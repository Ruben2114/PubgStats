//
//  StatsGeneralCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit
enum StatsGeneralTransition {
  
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
