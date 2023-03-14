//
//  ProfileFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

protocol ProfileFactory {
    func makeModule() -> UIViewController
}

struct ProfileFactoryImp: ProfileFactory {
    private(set) var appContainer: AppContainer
    
    func makeModule() -> UIViewController {
        let controller = ProfileViewController()
        controller.title = "Profile"
        return controller
    }
    
    
}
