//
//  PersonalDataCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

//
//  ForgotCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

protocol PersonalDataCoordinator: Coordinator {
}

final class PersonalDataCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: PersonalDataExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: PersonalDataExternalDependency, navigation: UINavigationController) {
        self.navigation = navigation
        self.externalDependencies = dependencies
    }
    
    func start() {
        let personalDataView: PersonalDataViewController = dependencies.resolve()
        navigation?.pushViewController(personalDataView, animated: false)
    }
}
extension PersonalDataCoordinatorImp: PersonalDataCoordinator {
    
}

private extension PersonalDataCoordinatorImp {
    struct Dependency: PersonalDataDependency {
        let external: PersonalDataExternalDependency
        weak var coordinator: PersonalDataCoordinator?
        
        func resolve() -> PersonalDataCoordinator? {
            return coordinator
        }
    }
}
