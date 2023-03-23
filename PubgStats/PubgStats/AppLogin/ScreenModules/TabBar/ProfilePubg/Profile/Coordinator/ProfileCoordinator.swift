//
//  ProfileCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

enum ProfileTransition {
    case goPersonalData
    case goSetting
    case goLinkPubg
    case goProfilePubg
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
        case .goPersonalData:
            print("goPersonalData")
        case .goSetting:
            print("goSetting")
        case .goLinkPubg:
            print("goLinkPubg")
        case .goProfilePubg:
            print("goProfilePubg")
        }
    }
}

private extension ProfileCoordinatorImp {
    struct Dependency: ProfileDependency {
        let external: ProfileExternalDependency
        let coordinator: ProfileCoordinator
        
        func resolve() -> ProfileCoordinator {
            return coordinator
        }
    }
}
