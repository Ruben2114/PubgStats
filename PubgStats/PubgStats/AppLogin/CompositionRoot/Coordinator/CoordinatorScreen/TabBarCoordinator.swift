//
//  TabBarCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var navigation: UINavigationController
    private let tabBarFactory: TabBarFactory
    
    init(navigation:UINavigationController, tabBarFactory: TabBarFactory){
        self.navigation = navigation
        self.tabBarFactory = tabBarFactory
    }
    
    func start() {
        let controller = tabBarFactory.makeModule()
        navigation.pushViewController(controller, animated: true)
        navigation.navigationBar.prefersLargeTitles = true
    }
}
