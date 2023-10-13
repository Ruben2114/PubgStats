//
//  ProfileCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

enum ProfileTransition {
    case goBackView
    case goStatsGeneral
}
protocol ProfileCoordinator: BindableCoordinator {
    func performTransition(_ transition: ProfileTransition)
}

final class ProfileCoordinatorImp: ProfileCoordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: ProfileExternalDependency
    lazy var dataBinding: DataBinding = dependencies.resolve()
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    public init(dependencies: ProfileExternalDependency) {
        self.externalDependencies = dependencies
        self.navigation = dependencies.profileNavigationController()
    }
    
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
}

extension ProfileCoordinatorImp {
    func performTransition(_ transition: ProfileTransition) {
        switch transition {
        case .goBackView:
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewAppCoordinator()
        case .goStatsGeneral:
            guard let navigationController = navigation else {return}
            let statsGeneralCoordinator = dependencies.external.statsGeneralCoordinator(navigation: navigationController, type: .profile)
            statsGeneralCoordinator.start()
            append(child: statsGeneralCoordinator)
        }
    }
}

private extension ProfileCoordinatorImp {
    struct Dependency: ProfileDependency {
        let external: ProfileExternalDependency
        unowned var coordinator: ProfileCoordinator
        let dataBinding = DataBindingObject()
        
        func resolve() -> ProfileCoordinator {
            coordinator
        }
        
        func resolve() -> ProfileCoordinator? {
            return coordinator
        }
        
        func resolve()  -> DataBinding {
            return dataBinding
        }
    }
}
