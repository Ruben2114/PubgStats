//
//  PersonalDataCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit

final class PersonalDataCoordinator: Coordinator {
    var navigation: UINavigationController
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    
    private let personalDataFactory: PersonalDataFactory
    
    init(navigation:UINavigationController, personalDataFactory: PersonalDataFactory){
        self.navigation = navigation
        self.personalDataFactory = personalDataFactory
    }
    
    func start() {
        let controller = personalDataFactory.makeModule(coordinator: self)
        navigation.pushViewController(controller, animated: true)
    }
}
extension PersonalDataCoordinator: PersonalDataViewControllerCoordinator {
    
}
