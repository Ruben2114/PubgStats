//
//  TabBarViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configTabBar()
    }
    
    func configTabBar() {
        
        let profileView = navController(vc: ProfileViewController(), itemName: "Buscar", itemImage: "magnifyingglass.circle.fill")
        let favouritesView = navController(vc: UIViewController(), itemName: "Perfil", itemImage: "person.circle.fill")
        let rankingView = navController(vc: UIViewController(), itemName: "Ranking", itemImage: "trophy.circle.fill")
        let guideView = navController(vc: UIViewController(), itemName: "Guia", itemImage: "book.circle.fill")
        viewControllers = [profileView, favouritesView, rankingView, guideView ]
        tabBar.backgroundColor = .white
    }
    
    func navController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)), tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
}
