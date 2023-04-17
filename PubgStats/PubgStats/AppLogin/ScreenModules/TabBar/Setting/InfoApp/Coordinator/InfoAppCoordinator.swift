//
//  InfoAppCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

import UIKit

protocol InfoAppCoordinator: Coordinator {
}

final class InfoAppCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: InfoAppExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: InfoAppExternalDependency, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
    
    func start() {
        let infoAppView: InfoAppViewController = dependencies.resolve()
        navigation?.pushViewController(infoAppView, animated: false)
    }
}
extension InfoAppCoordinatorImp: InfoAppCoordinator {
}

private extension InfoAppCoordinatorImp {
    struct Dependency: InfoAppDependency {
        let external: InfoAppExternalDependency
        weak var coordinator: InfoAppCoordinator?
        
        func resolve() -> InfoAppCoordinator? {
            return coordinator
        }
    }
}
