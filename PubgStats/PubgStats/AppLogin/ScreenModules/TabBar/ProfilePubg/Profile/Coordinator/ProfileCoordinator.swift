//
//  ProfileCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

enum ProfileTransition {
    case goLogOut
    case goPersonalData
    case goSetting
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
        case .goLogOut:
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewAppCoordinator()
        case .goPersonalData:
            let personalDataCoordinator = dependencies.external.personalDataCoordinator()
            personalDataCoordinator.start()
            append(child: personalDataCoordinator)
        case .goSetting:
            print("goSetting")
        case .goStatsGeneral:
            let statsGeneralCoordinator = dependencies.external.statsGeneralCoordinator()
            statsGeneralCoordinator.start()
            append(child: statsGeneralCoordinator)
        }
    }
}

private extension ProfileCoordinatorImp {
    struct Dependency: ProfileDependency {
        let external: ProfileExternalDependency
        weak var coordinator: ProfileCoordinator?
        
        func resolve() -> ProfileCoordinator? {
            return coordinator
        }
    }
}
