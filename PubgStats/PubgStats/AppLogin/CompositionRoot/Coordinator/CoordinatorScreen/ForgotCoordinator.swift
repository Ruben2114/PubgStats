//
//  ForgotCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit

final class ForgotCoordinator: Coordinator {
    var navigation: UINavigationController
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    
    private let forgotFactory: ForgotFactory
    
   
    init(navigation:UINavigationController, forgotFactory: ForgotFactory){
        self.navigation = navigation
        self.forgotFactory = forgotFactory
    }
    
    func start() {
        let controller = forgotFactory.makeModule(coordinator: self)
        navigation.pushViewController(controller, animated: true)
    }
}
extension ForgotCoordinator: ForgotViewControllerCoordinator {
    
}
