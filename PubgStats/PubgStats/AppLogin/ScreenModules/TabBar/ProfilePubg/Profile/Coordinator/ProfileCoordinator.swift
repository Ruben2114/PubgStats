//
//  ProfileCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol ProfileCoordinator: BindableCoordinator {
   
}

final class ProfileCoordinatorImp: ProfileCoordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: ProfileExternalDependency
    lazy var dataBinding: DataBinding = dependencies.resolve()
    private lazy var dependencies: Dependency = {
        Dependency(dependencies: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: ProfileExternalDependency) {
        self.externalDependencies = dependencies
        self.navigation = dependencies.profileNavigationController()
    }
}

extension ProfileCoordinatorImp {
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
}

private extension ProfileCoordinatorImp {
    struct Dependency: ProfileDependency {
        let dependencies: ProfileExternalDependency
        unowned let coordinator: ProfileCoordinator
        let dataBinding = DataBindingObject()
        
        var external: ProfileExternalDependency {
            return dependencies
        }
        
        func resolve() -> ProfileCoordinator {
            return coordinator
        }
        
        func resolve()  -> DataBinding {
            return dataBinding
        }
    }
}
