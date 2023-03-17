//
//  ChangeTabBarCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

final class ChangeTabBarCoordinator: Coordinator {
    var navigation: UINavigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?

    func start() {
        print("aqui estaba antes lo del cambio")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewTabCoordinator()
    }
}
