//
//  SettingsCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

public protocol SettingsCoordinator: BindableCoordinator {
    func goDeleteProfile()
    func goHelp()
}

final class SettingsCoordinatorImp: SettingsCoordinator {
    lazy var dataBinding: DataBinding = dependencies.resolve()
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: SettingsExternalDependencies
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: SettingsExternalDependencies, navigation: UINavigationController?) {
        self.externalDependencies = dependencies
        self.navigation = navigation
    }
}
extension SettingsCoordinatorImp {
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func goDeleteProfile() {
        setNewRoot()
    }
    
    func goHelp() {
        let helpDataCoordinator = dependencies.external.helpDataCoordinator(navigation: navigation)
        helpDataCoordinator.start()
        append(child: helpDataCoordinator)
    }
}

private extension SettingsCoordinatorImp {
    struct Dependency: SettingsDependencies {
        let external: SettingsExternalDependencies
        unowned var coordinator: SettingsCoordinator
        let dataBinding = DataBindingObject()
        
        func resolve() -> SettingsCoordinator {
            return coordinator
        }
        
        func resolve()  -> DataBinding {
            return dataBinding
        }
    }
}
