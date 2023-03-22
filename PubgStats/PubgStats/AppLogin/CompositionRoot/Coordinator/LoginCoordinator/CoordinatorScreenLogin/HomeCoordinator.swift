//
//  HomeCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

final class HomeCoordinator: Coordinator {
    var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    
    private let homeFactory: HomeFactory
    
    init(navigation:UINavigationController, homeFactory: HomeFactory){
        self.navigation = navigation
        self.homeFactory = homeFactory
    }
    
    func start() {
        let controller = homeFactory.makeModule(coordinator: self)
        navigation?.pushViewController(controller, animated: true)
    }
}

extension HomeCoordinator: LoginViewControllerCoordinator {
    func didTapLoginButton() {
        
    }
    func didTapForgotButton() {
        
    }
    
    func didTapRegisterButton() {
        
    }
}
