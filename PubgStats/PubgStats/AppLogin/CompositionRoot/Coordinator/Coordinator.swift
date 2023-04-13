//
//  Coordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

public protocol Coordinator: AnyObject {
    var identifier: String { get }
    var navigation: UINavigationController? { get set }
    var childCoordinators: [Coordinator] { get set }
    var onFinish: (() -> Void)? { get set }
    func start()
    func dismiss()
}

extension Coordinator {
    var identifier: String {
        return String(describing: self)
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



// pasar a otro fichero
public typealias BindableCoordinator = Coordinator & Bindable

public protocol Bindable {
    var dataBinding: DataBinding { get }
    func set<T>(_ value: T) -> Self
}

public extension Bindable {
    @discardableResult
    func set<T>(_ value: T) -> Self {
        dataBinding.set(value)
        return self
    }
}

public typealias DatabindingPredicate = (Any) -> Bool

public protocol DataBinding {
    func get<T>() -> T?
    func get<T>(_ predicate: DatabindingPredicate?) -> T?
    func set<T>(_ value: T)
    func contains<T>(_ type: T.Type) -> Bool
}

public class DataBindingObject: DataBinding {
    private var values: [Any] = []
    public init() {}
    public func get<T>() -> T? {
        return getElement()
    }
    public func get<T>(_ predicate: DatabindingPredicate? = nil) -> T? {
        return getElement(predicate: predicate)
    }
    public func set<T>(_ value: T) {
        defer { self.values.append(value) }
        guard let index = values.firstIndex(where: { $0 is T || $0 is T? }) else { return }
        values.remove(at: index)
    }
    public func contains<T>(_ type: T.Type) -> Bool {
        return values.contains(where: { $0 is T })
    }
}
private extension DataBindingObject {
    func getElement<T>(predicate: DatabindingPredicate? = nil) -> T? {
        let wherePredicate = predicate ?? { $0 is T || $0 is T? }
        guard let index = values.firstIndex(where: wherePredicate),
        let value = values[index] as? Optional<T> else {
           return nil
        }
        return value
    }
}
