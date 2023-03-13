//
//  HomeFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit
import Combine

protocol HomeFactory {
    func makeModule(coordinator: HomeMenuViewControllerCoordinator) -> UIViewController
    func makeLoginCoordinator(navigation: UINavigationController) //-> Coordinator
    func makeRegisterCoordinator(navigation: UINavigationController) -> Coordinator
}

struct HomeFactoryImp: HomeFactory {
    let appContainer: AppContainer
    
    func makeModule(coordinator: HomeMenuViewControllerCoordinator) -> UIViewController {
        let state = PassthroughSubject<StateController, Never>()
        let profileRepository = ProfileRepositoryImp(dataSource: appContainer.localDataService)
        let profileDataUseCase = ProfileDataUseCaseImp(profileRepository: profileRepository)
        let viewModel = HomeMenuViewModel(state: state, profileDataUseCase: profileDataUseCase)
        let homeMenuController = HomeMenuViewController(coordinator: coordinator, viewModel: viewModel)
        homeMenuController.title = "Login"
        return homeMenuController
    }
    func makeLoginCoordinator(navigation: UINavigationController) {
        //TODO: crear vista perfil y crear aqui el cooordinator
        print("navegando hacia login")
        
    }
    
    func makeRegisterCoordinator(navigation: UINavigationController) -> Coordinator {
        let registerFactory = RegisterFactoryImp(appContainer: appContainer)
        let registerCoordinator = RegisterCoordinator(navigation: navigation, registerFactory: registerFactory)
        return registerCoordinator
    }
}
