//
//  HelpDataCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

import UIKit

protocol HelpDataCoordinator: Coordinator {
}

final class HelpDataCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: HelpDataExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: HelpDataExternalDependency, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
    
    func start() {
        let helpDataView: HelpDataViewController = dependencies.resolve()
        navigation?.pushViewController(helpDataView, animated: false)
    }
}
extension HelpDataCoordinatorImp: HelpDataCoordinator {
    
}

private extension HelpDataCoordinatorImp {
    struct Dependency: HelpDataDependency {
        let external: HelpDataExternalDependency
        weak var coordinator: HelpDataCoordinator?
        
        func resolve() -> HelpDataCoordinator? {
            return coordinator
        }
    }
}
