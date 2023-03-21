//
//  TabBarFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/3/23.
//

import UIKit

protocol TabBarFactory {
    func allView(coordinator: Coordinator) -> [UIViewController]
    func makeProfileCoordinator(navigation: UINavigationController) -> Coordinator
}

struct TabBarFactoryImp:  TabBarFactory, CreateNavController{
    func allView(coordinator: Coordinator) -> [UIViewController]{
        let appContainer = AppContainerImp()
        let profileFactory = ProfileFactoryImp(appContainer: appContainer)
        let profileView = profileFactory.makeModule(coordinator: coordinator as! ProfileViewControllerCoordinator)
        let favouritesView = navController(vc: UIViewController(), itemName: "Favourite", itemImage: "star.circle.fill")
        let rankingView = navController(vc: UIViewController(), itemName: "Ranking", itemImage: "trophy.circle.fill")
        let guideView = navController(vc: GuideViewController(viewModel: GuideViewModel()), itemName: "Guide", itemImage: "book.circle.fill")
        let contactView = navController(vc: ContactViewController(), itemName: "Contact", itemImage: "envelope.circle.fill")
        return [profileView, favouritesView, rankingView, guideView, contactView]
    }

    func makeProfileCoordinator(navigation: UINavigationController) -> Coordinator {
        let appContainer = AppContainerImp()
        let profileFactory = ProfileFactoryImp(appContainer: appContainer)
        let profileCoordinator = ProfileCoordinator(navigation: navigation, profileFactory: profileFactory)
        return profileCoordinator
    }
    
}
