//
//  ProfileFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import Combine

protocol ProfileFactory {
    func makeModule() -> UIViewController
    func makeLogOutDataCoordinator() -> Coordinator
    func makePersonalDataCoordinator(navigation: UINavigationController) -> Coordinator
    func makeSettingCoordinator(navigation: UINavigationController) //-> Coordinator
    //TODO: este ultimo creo que no hace falta
    func makeLinkPubgDataCoordinator(navigation: UINavigationController) //-> Coordinator
    //TODO: meter el otro boton de stat
}

struct ProfileFactoryImp: ProfileFactory, CreateNavController{
    private(set) var appContainer: AppContainer
    
    func makeModule() -> UIViewController {
        UIViewController()
    }
    func makeLogOutDataCoordinator() -> Coordinator {
        let changeLoginCoordinator = ChangeLoginCoordinator()
        return changeLoginCoordinator
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
