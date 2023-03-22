//
//  HomeFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

protocol HomeFactory {
    func makeModule(coordinator: LoginViewControllerCoordinator) -> UIViewController
    func makeLoginCoordinator() //-> Coordinator
    func makeRegisterCoordinator(navigation: UINavigationController) //-> Coordinator
}

struct HomeFactoryImp: HomeFactory {
    private(set) var appContainer: AppContainer
    
    func makeModule(coordinator: LoginViewControllerCoordinator) -> UIViewController {
        
        UIViewController()
        
    }
    func makeLoginCoordinator()  {
        
    }
  
    
    func makeRegisterCoordinator(navigation: UINavigationController) {
        
    }
}
