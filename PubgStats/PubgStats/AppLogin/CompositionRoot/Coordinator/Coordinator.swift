//
//  Coordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

protocol Coordinator: AnyObject {
    var identifier: String { get }
    var navigation: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var onFinish: (() -> Void)? { get set }
    
    func start()
    func dismiss()
}

extension Coordinator {
    var identifier: String {
        return String(describing: self)
    }
    
    func append(child coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.onFinish = { [weak self, weak coordinator] in
            self?.childCoordinators.removeAll(where: { $0.identifier == coordinator?.identifier })
        }
    }
    
    func dismiss() {
        navigation.popViewController(animated: true)
        onFinish?()
    }
}
