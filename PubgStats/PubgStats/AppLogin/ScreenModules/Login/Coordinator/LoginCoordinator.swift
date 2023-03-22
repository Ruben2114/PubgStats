//
//  LoginCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

enum LoginTransition {
    case goForgot
}
protocol LoginCoordinator: Coordinator {
    func performTransition(_ transition: LoginTransition)
}

final class LoginCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: LoginExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()

    public init(dependencies: LoginExternalDependency) {
        self.externalDependencies = dependencies
        self.navigation = dependencies.loginNavigationController()
    }
    
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
    
}
extension LoginCoordinatorImp: LoginCoordinator {
    func performTransition(_ transition: LoginTransition) {
        switch transition {
        case .goForgot:
            let forgotCoordinator = dependencies.external.forgotCoordinator()
            forgotCoordinator.start()
            append(child: forgotCoordinator)
        }
    }
}

private extension LoginCoordinatorImp {
    struct Dependency: LoginDependency {
        let external: LoginExternalDependency
        let coordinator: LoginCoordinator
        
        func resolve() -> LoginCoordinator {
            return coordinator
        }
    }
}
