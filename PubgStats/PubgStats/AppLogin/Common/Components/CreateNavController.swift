//
//  CreateNavController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/3/23.
//

import UIKit

protocol CreateNavController {
    func navController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController
}

extension CreateNavController {
    func navController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)), tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
}
