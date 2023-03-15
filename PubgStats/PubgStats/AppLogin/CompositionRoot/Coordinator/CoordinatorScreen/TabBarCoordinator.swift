//
//  TabBarCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var navigation: UINavigationController {
        UINavigationController()
    }
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    
    private let tabBarFactory: TabBarFactory
    
    init(tabBarFactory: TabBarFactory){
        self.tabBarFactory = tabBarFactory
    }
    
    func start() {
        let controller = tabBarFactory.makeModule()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(controller)
    }
}
