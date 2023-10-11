//
//  LoginCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

protocol LoginCoordinator: Coordinator {
    func goToProfile(player: String)
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
        self.navigation?.setNavigationBarHidden(true, animated: false)
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
        
    }
}
extension LoginCoordinatorImp: LoginCoordinator {
    func goToProfile(player: String) {
        DispatchQueue.main.async {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewTabCoordinator(player: player)
        }
    }
}

private extension LoginCoordinatorImp {
    struct Dependency: LoginDependency {
        let external: LoginExternalDependency
        weak var coordinator: LoginCoordinator?
        
        func resolve() -> LoginCoordinator? {
            return coordinator
        }
    }
}
