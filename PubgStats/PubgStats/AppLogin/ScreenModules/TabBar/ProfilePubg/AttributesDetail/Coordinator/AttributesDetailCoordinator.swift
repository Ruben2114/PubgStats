//
//  AttributesDetailCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

public protocol AttributesDetailCoordinator: BindableCoordinator {
    func goBack()
}

final class AttributesDetailCoordinatorImp: AttributesDetailCoordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: AttributesDetailExternalDependencies
    lazy var dataBinding: DataBinding = dependencies.resolve()
    private lazy var dependencies: Dependency = {
        Dependency(dependencies: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: AttributesDetailExternalDependencies, navigation: UINavigationController?) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
}
extension AttributesDetailCoordinatorImp {
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func goBack() {
        self.dismiss()
    }
}

private extension AttributesDetailCoordinatorImp {
    struct Dependency: AttributesDetailDependencies {
        let dependencies: AttributesDetailExternalDependencies
        unowned var coordinator: AttributesDetailCoordinator
        let dataBinding = DataBindingObject()
        
        var external: AttributesDetailExternalDependencies {
            return dependencies
        }
        
        func resolve()  -> DataBinding {
            return dataBinding
        }
        func resolve() -> AttributesDetailCoordinator {
            return coordinator
        }
    }
}
