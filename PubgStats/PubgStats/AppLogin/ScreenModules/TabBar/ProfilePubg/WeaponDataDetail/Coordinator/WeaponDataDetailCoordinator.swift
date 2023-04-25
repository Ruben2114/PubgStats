//
//  WeaponDataDetailCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

import UIKit

protocol WeaponDataDetailCoordinator: Coordinator {
    var type: NavigationStats {get}
}

final class WeaponDataDetailCoordinatorImp: Coordinator {
    var type: NavigationStats
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: WeaponDataDetailExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: WeaponDataDetailExternalDependency, navigation: UINavigationController, type: NavigationStats) {
        self.navigation = navigation
        self.externalDependencies = dependencies
        self.type = type
    }
    
    func start() {
        let weaponDataDetailView: WeaponDataDetailViewController = dependencies.resolve()
        navigation?.pushViewController(weaponDataDetailView, animated: false)
    }
}
extension WeaponDataDetailCoordinatorImp: WeaponDataDetailCoordinator {}

private extension WeaponDataDetailCoordinatorImp {
    struct Dependency: WeaponDataDetailDependency {
        let external: WeaponDataDetailExternalDependency
        weak var coordinator: WeaponDataDetailCoordinator?
        
        func resolve() -> WeaponDataDetailCoordinator? {
            return coordinator
        }
    }
}
