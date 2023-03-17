//
//  ProfileFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import Combine

protocol ProfileFactory {
    func makeModule(coordinator: ProfilePubgViewControllerCoordinator) -> UIViewController
    func makePersonalDataCoordinator(navigation: UINavigationController) -> Coordinator
    func makeSettingCoordinator(navigation: UINavigationController) //-> Coordinator
    //TODO: este ultimo creo que no hace falta
    func makeLinkPubgDataCoordinator(navigation: UINavigationController) //-> Coordinator
}

struct ProfileFactoryImp: ProfileFactory, CreateNavController{
    private(set) var appContainer: AppContainer
    
    func makeModule(coordinator: ProfilePubgViewControllerCoordinator) -> UIViewController {
        let profileView = navController(vc: ProfilePubgViewController(coordinator: coordinator), itemName: "Profile", itemImage: "person.circle.fill")
        return profileView
        //let profileController = ProfilePubgViewController(coordinator: coordinator)
        //return profileController
    }
    
    func makePersonalDataCoordinator(navigation: UINavigationController) -> Coordinator {
        let personalDataFactory = PersonalDataFactoryImp(appContainer: appContainer)
        let personalDataCoordinator = PersonalDataCoordinator(navigation:navigation, personalDataFactory: personalDataFactory)
        return personalDataCoordinator
    }
    
    func makeSettingCoordinator(navigation: UINavigationController) {
        
    }
    
    func makeLinkPubgDataCoordinator(navigation: UINavigationController) {
        
    }
    
    
}
