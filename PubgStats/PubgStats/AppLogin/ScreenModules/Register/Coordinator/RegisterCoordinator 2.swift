//
//  RegisterCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit


protocol RegisterCoordinator: Coordinator {
}

final class RegisterCoordinatorImp: Coordinator{
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: RegisterExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    init(dependencies: RegisterExternalDependency, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
    func start() {
        let registerView: RegisterViewController = dependencies.resolve()
        registerView.modalTransitionStyle = .coverVertical
        navigation?.present(registerView, animated: true)
    }
}
extension RegisterCoordinatorImp: RegisterCoordinator {
}
private extension RegisterCoordinatorImp {
    struct Dependency: RegisterDependency{
        let external: RegisterExternalDependency
        weak var coordinator: RegisterCoordinator?
        
        func resolve() -> RegisterCoordinator? {
            return coordinator
        }
    }
}
