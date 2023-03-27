//
//  RegisterCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

enum RegisterTransition {
    case goAccept
}
protocol RegisterCoordinator: Coordinator {
    func performTransition(_ transition: RegisterTransition)
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
        navigation?.pushViewController(registerView, animated: false)
    }
}
extension RegisterCoordinatorImp: RegisterCoordinator {
    func performTransition(_ transition: RegisterTransition) {
        switch transition {
        case .goAccept:
            dismiss()
        }
    }
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
