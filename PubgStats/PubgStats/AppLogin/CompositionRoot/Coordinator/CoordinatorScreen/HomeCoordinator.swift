//
//  HomeCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

final class HomeCoordinator: Coordinator {
    var navigation: UINavigationController
    private let homeFactory: HomeFactory
    
    init(navigation:UINavigationController, homeFactory: HomeFactory){
        self.navigation = navigation
        self.homeFactory = homeFactory
    }
    
    func start() {
        let controller = homeFactory.makeModule(coordinator: self)
        navigation.pushViewController(controller, animated: true)
    }
}

extension HomeCoordinator: HomeMenuViewControllerCoordinator {
    func didTapLoginButton() {
        let loginCoordinator = homeFactory.makeLoginCoordinator()
        loginCoordinator.start(navigation: )
    }
    func didTapForgotButton() {
        let forgotCoordinator = homeFactory.makeForgotCoordinator()
        forgotCoordinator.start()
    }
    
    func didTapRegisterButton() {
        let registerCoordinator = homeFactory.makeRegisterCoordinator()
        registerCoordinator.start()
    }
}
