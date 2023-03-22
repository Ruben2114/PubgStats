//
//  ForgotCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

protocol ForgotCoordinator: Coordinator {
    
}

final class ForgotCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: ForgotExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: ForgotExternalDependency, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
    
    func start() {
        let forgotView: ForgotViewController = dependencies.resolve()
        navigation?.pushViewController(forgotView, animated: false)
    }
}
extension ForgotCoordinatorImp: ForgotCoordinator {}

private extension ForgotCoordinatorImp {
    struct Dependency: ForgotDependency {
        let external: ForgotExternalDependency
        let coordinator: ForgotCoordinator
        
        func resolve() -> ForgotCoordinator {
            return coordinator
        }
    }
}
