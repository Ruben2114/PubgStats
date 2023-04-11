//
//  SurvivalDataCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import UIKit

protocol SurvivalDataCoordinator: Coordinator {
}

final class SurvivalDataCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: SurvivalDataExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: SurvivalDataExternalDependency, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
    
    func start() {
        let survivalDataView: SurvivalDataViewController = dependencies.resolve()
        navigation?.pushViewController(survivalDataView, animated: false)
    }
}
extension SurvivalDataCoordinatorImp: SurvivalDataCoordinator {
    
}

private extension SurvivalDataCoordinatorImp {
    struct Dependency: SurvivalDataDependency {
        let external: SurvivalDataExternalDependency
        weak var coordinator: SurvivalDataCoordinator?
        
        func resolve() -> SurvivalDataCoordinator? {
            return coordinator
        }
    }
}
