//
//  LoginCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

public protocol LoginCoordinator: Coordinator {
    func goToProfile(data: IdAccountDataProfileRepresentable)
}

final class LoginCoordinatorImp: LoginCoordinator {
    weak var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    private let externalDependencies: LoginExternalDependencies
    
    private lazy var dependencies: Dependency = {
        Dependency(dependencies: externalDependencies, coordinator: self)
    }()

    public init(dependencies: LoginExternalDependencies) {
        self.externalDependencies = dependencies
    }
}

extension LoginCoordinatorImp {
    func start() {
        setRoot(dependencies.resolve())
    }
    
    func goToProfile(data: IdAccountDataProfileRepresentable) {
        setNewRoot(data)
    }
}

private extension LoginCoordinatorImp {
    struct Dependency: LoginDependencies {
        let dependencies: LoginExternalDependencies
        unowned let coordinator: LoginCoordinator
        let dataBinding = DataBindingObject()
        
        var external: LoginExternalDependencies {
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
