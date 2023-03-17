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
    
    //private let profileFactory: ProfileFactory
    
    init(navigation:UINavigationController){
        self.navigation = navigation
    }
    
    func start() {
        //let controller = profileFactory.makeModule(coordinator: self)
        //navigation.pushViewController(controller, animated: true)
    }
}
extension ProfileCoordinator: ProfilePubgViewControllerCoordinator {
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
