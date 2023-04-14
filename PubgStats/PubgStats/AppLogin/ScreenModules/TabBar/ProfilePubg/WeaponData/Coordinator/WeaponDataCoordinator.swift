//
//  WeaponDataCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit
enum WeaponTransition {
    case goWeapon
}
protocol WeaponDataCoordinator: Coordinator {
    func performTransition(_ transition: WeaponTransition)
}

final class WeaponDataCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: WeaponDataExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: WeaponDataExternalDependency, navigation: UINavigationController) {
        self.externalDependencies = dependencies
        self.navigation = navigation
    }
    
    func start() {
        let weaponDataView: WeaponDataViewController = dependencies.resolve()
        navigation?.pushViewController(weaponDataView, animated: false)
    }
}
extension WeaponDataCoordinatorImp: WeaponDataCoordinator {
    func performTransition(_ transition: WeaponTransition) {
        switch transition{
        case .goWeapon:
            guard let navigationController = navigation else {return}
            let weaponDatDetailCoordinator = dependencies.external.weaponDataDetailCoordinator(navigation: navigationController)
            weaponDatDetailCoordinator.start()
            append(child: weaponDatDetailCoordinator)
        }
    }
}

private extension WeaponDataCoordinatorImp {
    struct Dependency: WeaponDataDependency {
        let external: WeaponDataExternalDependency
        weak var coordinator: WeaponDataCoordinator?
        
        func resolve() -> WeaponDataCoordinator? {
            return coordinator
        }
    }
}
