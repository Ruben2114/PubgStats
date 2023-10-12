//
//  LoginCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

public protocol LoginCoordinator: Coordinator {
    func goToProfile(player: String, id: String)
}

final class LoginCoordinatorImp: LoginCoordinator {
    weak var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    private let externalDependencies: LoginExternalDependency
    
    private lazy var dependencies: Dependency = {
        Dependency(dependencies: externalDependencies,
                   coordinator: self)
    }()

    public init(dependencies: LoginExternalDependency, navigation: UINavigationController?) {
        self.externalDependencies = dependencies
        self.navigation = navigation
    }
}

extension LoginCoordinatorImp {
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
        
    }
    
    func goToProfile(player: String, id: String) {
        DispatchQueue.main.async {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewTabCoordinator(player: player, id: id)
        }
    }
}

private extension LoginCoordinatorImp {
    struct Dependency: LoginDependency {
        let dependencies: LoginExternalDependency
        unowned var coordinator: LoginCoordinator
        let dataBinding = DataBindingObject()
        
        var external: LoginExternalDependency {
            return  dependencies
        }
        
        func resolve() -> LoginCoordinator {
            return coordinator
        }
        
        func resolve()  -> DataBinding {
            return dataBinding
        }
    }
}
