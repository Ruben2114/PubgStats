//
//  AttributesHomeCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

protocol AttributesHomeCoordinator: BindableCoordinator {
    func goToAttributesDetails(_ attributes: AttributesViewRepresentable?)
    func goBack()
}

final class AttributesHomeCoordinatorImp: AttributesHomeCoordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: AttributesHomeExternalDependencies
    lazy var dataBinding: DataBinding = dependencies.resolve()
    private lazy var dependencies: Dependency = {
        Dependency(dependencies: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: AttributesHomeExternalDependencies, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
}

extension AttributesHomeCoordinatorImp {
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func goToAttributesDetails(_ attributes: AttributesViewRepresentable?) {
        //TODO: ver como quitar el !
        let coordinator = dependencies.external.attributesDetailCoordinator(navigation: navigation!)
        coordinator
            .set(attributes)
            .start()
        append(child: coordinator)
    }
    
    func goBack() {
        self.dismiss()
    }
}

private extension AttributesHomeCoordinatorImp {
    struct Dependency: AttributesHomeDependencies {
        let dependencies: AttributesHomeExternalDependencies
        unowned var coordinator: AttributesHomeCoordinator
        let dataBinding = DataBindingObject()
        
        var external: AttributesHomeExternalDependencies {
            return dependencies
        }
        
        func resolve()  -> DataBinding {
            return dataBinding
        }
        func resolve() -> AttributesHomeCoordinator {
            return coordinator
        }
    }
}
