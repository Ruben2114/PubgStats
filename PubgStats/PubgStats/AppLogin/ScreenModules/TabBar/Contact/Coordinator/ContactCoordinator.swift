//
//  ContactCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol ContactCoordinator: Coordinator {
    
}
final class ContactCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: ContactExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    public init(dependencies: ContactExternalDependency) {
        self.externalDependencies = dependencies
        self.navigation = dependencies.contactNavigationController()
    }
        
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
}
extension ContactCoordinatorImp: ContactCoordinator {}

private extension ContactCoordinatorImp {
    struct Dependency: ContactDependency {
        let external: ContactExternalDependency
        let coordinator: ContactCoordinator
        
        func resolve() -> ContactCoordinator {
            return coordinator
        }
    }
}
