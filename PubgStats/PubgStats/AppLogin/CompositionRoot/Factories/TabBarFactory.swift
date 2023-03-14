//
//  ProfileFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

protocol TabBarFactory {
    func makeModule() -> UIViewController
}

struct TabBarFactoryImp: TabBarFactory {
    private(set) var appContainer: AppContainer
    
    func makeModule() -> UIViewController {
        let controller = TabBarViewController()
        //añadir aqui todos los controller y hacerlos tabbar para mandarlos
        controller.title = "Profile"
        return controller
    }
}
