//
//  MatchesCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 9/4/24.
//

import UIKit

public protocol MatchesCoordinator: BindableCoordinator {
    func goBack()
}

final class MatchesCoordinatorImp: MatchesCoordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: MatchesExternalDependencies
    lazy var dataBinding: DataBinding = dependencies.resolve()
    private lazy var dependencies: Dependency = {
        Dependency(dependencies: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: MatchesExternalDependencies, navigation: UINavigationController?) {
        self.externalDependencies = dependencies
        self.navigation = navigation
    }
}

extension MatchesCoordinatorImp {
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func goBack() {
        self.dismiss()
    }
}

private extension MatchesCoordinatorImp {
    struct Dependency: MatchesDependencies {
        let dependencies: MatchesExternalDependencies
        unowned let coordinator: MatchesCoordinator
        let dataBinding = DataBindingObject()
        
        var external: MatchesExternalDependencies {
            return dependencies
        }
        
        func resolve() -> MatchesCoordinator {
            return coordinator
        }
        
        func resolve()  -> DataBinding {
            return dataBinding
        }
    }
}
