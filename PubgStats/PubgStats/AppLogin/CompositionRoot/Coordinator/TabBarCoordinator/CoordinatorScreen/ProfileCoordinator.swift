//
//  ProfileCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var navigation: UINavigationController
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    
    private let profileFactory: ProfileFactory
    
    init(navigation:UINavigationController, profileFactory: ProfileFactory){
        self.navigation = navigation
        self.profileFactory = profileFactory
    }
    
    func start() {
    }
}
extension ProfileCoordinator: ProfileViewControllerCoordinator {
    func logOut() {
        let logOutCoordinator = profileFactory.makeLogOutDataCoordinator()
        logOutCoordinator.start()
        append(child: logOutCoordinator)
    }
    
    func didTapStatsgAccountButton() {
        
    }
    
    func didTapPersonalDataButton() {
        //let personalDataCoordinator = profileFactory.makePersonalDataCoordinator(navigation: navigation)
        //personalDataCoordinator.start()
        //append(child: personalDataCoordinator)
    }
    
    func didTapSettingButton() {
        
    }
    
    func didTapLinkPubgAccountButton() {
        
    }
    
}
