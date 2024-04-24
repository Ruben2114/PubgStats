//
//  HelpDataCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

import UIKit

public protocol HelpDataCoordinator: Coordinator {
    func goBack()
}

final class HelpDataCoordinatorImp: HelpDataCoordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: HelpDataExternalDependencies
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: HelpDataExternalDependencies, navigation: UINavigationController?) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
}
extension HelpDataCoordinatorImp {
    func start() {
        let helpDataView: HelpDataViewController = dependencies.resolve()
        navigation?.pushViewController(helpDataView, animated: false)
    }
    
    func goBack() {
        dismiss()
    }
}

private extension HelpDataCoordinatorImp {
    struct Dependency: HelpDataDependencies {
        let external: HelpDataExternalDependencies
        unowned var coordinator: HelpDataCoordinator
        
        func resolve() -> HelpDataCoordinator {
            return coordinator
        }
    }
}
