//
//  ProfileCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol ProfileCoordinator: BindableCoordinator {
    func goToAttributes(attributes: [AttributesViewRepresentable], type: AttributesType)
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
    
    public init(dependencies: ProfileExternalDependency, navigation: UINavigationController) {
        self.externalDependencies = dependencies
        self.navigation = navigation
    }
}

extension ProfileCoordinatorImp {
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func goToAttributes(attributes: [AttributesViewRepresentable], type: AttributesType) {
        //TODO: ver como se hace en la app para no forzar !
        let coordinator = dependencies.external.attributesHomeCoordinator(navigation: navigation!)
        coordinator
            .set(attributes)
            .set(type)
            .start()
        append(child: coordinator)
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
