//
//  GuideCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol GuideCoordinator: Coordinator {
    
}
final class GuideCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: GuideExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    public init(dependencies: GuideExternalDependency) {
        self.externalDependencies = dependencies
        self.navigation = dependencies.guideNavigationController()
    }
        
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
}
extension GuideCoordinatorImp: GuideCoordinator {}

private extension GuideCoordinatorImp {
    struct Dependency: GuideDependency {
        let external: GuideExternalDependency
        let coordinator: GuideCoordinator
        
        func resolve() -> GuideCoordinator {
            return coordinator
        }
    }
}
