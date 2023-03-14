//
//  ProfileCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var navigation: UINavigationController
    private let profileFactory: ProfileFactory
    
    init(navigation:UINavigationController, profileFactory: ProfileFactory){
        self.navigation = navigation
        self.profileFactory = profileFactory
    }
    
    func start() {
        let controller = profileFactory.makeModule()
        navigation.pushViewController(controller, animated: true)
        navigation.navigationBar.prefersLargeTitles = true
    }
}
