//
//  KillsDataCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

protocol KillsDataCoordinator: Coordinator {
    var type: NavigationStats {get}
}

final class KillsDataCoordinatorImp: Coordinator {
    var type: NavigationStats
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: KillsDataExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: KillsDataExternalDependency, navigation: UINavigationController, type: NavigationStats) {
        self.navigation = navigation
        self.externalDependencies = dependencies
        self.type = type
    }
    
    func start() {
        let killDataView: KillsDataViewController = dependencies.resolve()
        navigation?.pushViewController(killDataView, animated: false)
    }
}
extension KillsDataCoordinatorImp: KillsDataCoordinator {}

private extension KillsDataCoordinatorImp {
    struct Dependency: KillsDataDependency {
        let external: KillsDataExternalDependency
        weak var coordinator: KillsDataCoordinator?
        
        func resolve() -> KillsDataCoordinator? {
            return coordinator
        }
    }
}
