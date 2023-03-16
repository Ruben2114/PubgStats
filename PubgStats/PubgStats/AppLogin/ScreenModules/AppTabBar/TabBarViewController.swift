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
        
        let profileView = navController(vc: LoginProfilePubgViewController(), itemName: "Profile", itemImage: "person.circle.fill")
        let favouritesView = navController(vc: UIViewController(), itemName: "Favourite", itemImage: "star.circle.fill")
        let rankingView = navController(vc: UIViewController(), itemName: "Ranking", itemImage: "trophy.circle.fill")
        let guideView = navController(vc: GuideViewController(viewModel: GuideViewModel()), itemName: "Guide", itemImage: "book.circle.fill")
        let contactGuideView = navController(vc: ContactViewController(), itemName: "Contact", itemImage: "envelope.circle.fill")
        viewControllers = [profileView, favouritesView, rankingView, guideView,contactGuideView ]
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
