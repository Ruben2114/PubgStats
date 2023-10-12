//
//  Coordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

public typealias BindableCoordinator = Coordinator & Bindable

public protocol Coordinator: AnyObject, uniqueIdentifiable {
    var identifier: String { get }
    var childCoordinators: [Coordinator] { get set }
    var navigation: UINavigationController? { get set }
    var onFinish: (() -> Void)? { get set }
    func start()
    func dismiss()
}

public extension Coordinator {
    var identifier: String {
        return String(describing: self)
    }
    
    var uniqueIdentifer: Int {
        return identifier.hashValue
    }
    
    var onFinish: (() -> Void)? {
        return nil
    }
    
    func append(child coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.onFinish = { [weak self, weak coordinator] in
            self?.childCoordinators.removeAll(where: { $0.identifier == coordinator?.identifier })
        }
    }
    
    func dismiss() {
        navigation?.popViewController(animated: true)
        onFinish?()
    }
}

public protocol uniqueIdentifiable {
    var uniqueIdentifer: Int { get }
}

func ==<T: uniqueIdentifiable>(lhs: T, rhs: T) -> Bool {
    return lhs.uniqueIdentifer == rhs.uniqueIdentifer
}
