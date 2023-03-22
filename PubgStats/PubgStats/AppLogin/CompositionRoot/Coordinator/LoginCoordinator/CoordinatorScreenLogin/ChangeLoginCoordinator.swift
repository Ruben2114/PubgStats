//
//  ChangeLoginCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/3/23.
//

import UIKit

final class ChangeLoginCoordinator: Coordinator {
    var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?

    func start() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewAppCoordinator()
    }
}
