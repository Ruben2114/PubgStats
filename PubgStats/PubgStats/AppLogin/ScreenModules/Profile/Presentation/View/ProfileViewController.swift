//
//  ProfileViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

class ProfileViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configuracionTabBar()
    }
    
    func configuracionTabBar() {
        let buscadorLoginView = crearNavController(vc: UIViewController(), itemNombre: "Buscar", itemImagen: "magnifyingglass.circle.fill")
        let favoritosView = crearNavController(vc: UIViewController(), itemNombre: "Perfil", itemImagen: "person.circle.fill")
        let rankingView = crearNavController(vc: UIViewController(), itemNombre: "Ranking", itemImagen: "trophy.circle.fill")
        let guiaView = crearNavController(vc: UIViewController(), itemNombre: "Guia", itemImagen: "book.circle.fill")
        viewControllers = [buscadorLoginView, favoritosView, rankingView, guiaView ]
        tabBar.backgroundColor = .white
    }
    
    func crearNavController(vc: UIViewController, itemNombre: String, itemImagen: String) -> UINavigationController {
        let item = UITabBarItem(title: itemNombre, image: UIImage(systemName: itemImagen)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)), tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
}

