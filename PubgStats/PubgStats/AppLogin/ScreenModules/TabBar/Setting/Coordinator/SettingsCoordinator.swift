//
//  SettingsCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

enum SettingsTransition {
    case goDeleteProfile
    case goInfoDeveloper
    case goHelp
}

protocol SettingsCoordinator: Coordinator {
    func performTransition(_ transition: SettingsTransition)
}
final class SettingsCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: SettingsExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    public init(dependencies: SettingsExternalDependency) {
        self.externalDependencies = dependencies
        self.navigation = dependencies.settingsNavigationController()
    }
        
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
}
extension SettingsCoordinatorImp: SettingsCoordinator {
    func performTransition(_ transition: SettingsTransition) {
        switch transition {
        case .goInfoDeveloper:
            print("goInfoDeveloper")
        case .goHelp:
            let helpDataCoordinator = dependencies.external.helpDataCoordinator()
            helpDataCoordinator.start()
            append(child: helpDataCoordinator)
        case .goDeleteProfile:
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewAppCoordinator()
        }
    }
}

private extension SettingsCoordinatorImp {
    struct Dependency: SettingsDependency {
        let external: SettingsExternalDependency
        weak var coordinator: SettingsCoordinator?
        
        func resolve() -> SettingsCoordinator? {
            return coordinator
        }
    }
}
