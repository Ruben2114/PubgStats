//
//  ForgotFactory.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import Combine
import UIKit

protocol ForgotFactory {
    func makeModule(coordinator: ForgotViewControllerCoordinator) -> UIViewController
}

struct ForgotFactoryImp : ForgotFactory {
    private(set) var appContainer: AppContainer
    
    func makeModule(coordinator: ForgotViewControllerCoordinator) -> UIViewController {
        let forgotController = ForgotViewController()
        forgotController.title = "Forgot"
        return forgotController
    }
}
