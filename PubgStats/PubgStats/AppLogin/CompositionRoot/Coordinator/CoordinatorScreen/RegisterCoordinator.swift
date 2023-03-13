//
//  RegisterCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import UIKit

final class RegisterCoordinator: Coordinator {
    var navigation: UINavigationController
    private let registerFactory: RegisterFactory
    
    init(navigation:UINavigationController, registerFactory: RegisterFactory){
        self.navigation = navigation
        self.registerFactory = registerFactory
    }
    
    func start() {
        let controller = registerFactory.makeModule(coordinator: self)
        navigation.pushViewController(controller, animated: true)
    }
}

extension RegisterCoordinator: RegisterViewControllerCoordinator {
    func didTapAcceptButton() {
        let registerCoordinator = registerFactory.makeAcceptCoordinator(navigation: navigation)
        registerCoordinator.start()
    }
    
}
