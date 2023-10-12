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
protocol ProfileCoordinator: Coordinator {
    func performTransition(_ transition: ProfileTransition)
}

final class ProfileCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: ProfileExternalDependency
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

extension ProfileCoordinatorImp: ProfileCoordinator {
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
        func resolve() -> ProfileCoordinator {
            coordinator
        }
        
        let external: ProfileExternalDependency
        unowned var coordinator: ProfileCoordinator
        
        func resolve() -> ProfileCoordinator? {
            return coordinator
        }
    }
}
