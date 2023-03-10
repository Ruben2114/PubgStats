//
//  HomeFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

protocol HomeFactory {
    func makeModule(coordinator: HomeMenuViewControllerCoordinator) -> UIViewController
    func makeLoginCoordinator(navigation: UINavigationController) //-> Coordinator
    func makeRegisterCoordinator(navigation: UINavigationController) //-> Coordinator
}

struct HomeFactoryImp: HomeFactory {
    
    
    func makeModule(coordinator: HomeMenuViewControllerCoordinator) -> UIViewController {
        let viewModel = HomeMenuViewModel()
        let homeMenuController = HomeMenuViewController(coordinator: coordinator, viewModel: viewModel)
        homeMenuController.title = "Login"
        return homeMenuController
    }
    func makeLoginCoordinator(navigation: UINavigationController) {
        print("navegando hacia login")
        
    }
    
    func makeRegisterCoordinator(navigation: UINavigationController) {
        print("navegando hacia register")
       
    }
}
