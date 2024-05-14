//
//  MainTabBarCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol MainTabBarCoordinator: Coordinator { 
    func tabBarSelect(_ item: String)
}

final class MainTabBarCoordinatorImp: MainTabBarCoordinator {
    lazy var dataBinding: DataBinding = dependencies.resolve()
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: MainTabBarExternalDependencies
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    private var selectedTabBarIndex: Int = 0
    private var dataProfile: IdAccountDataProfileRepresentable?
    private var tabBarView: [UINavigationController] = []
    
    public init(dependencies: MainTabBarExternalDependencies, data: IdAccountDataProfileRepresentable?) {
        self.externalDependencies = dependencies
        self.dataProfile = data
    }
    
    func start() {
        tabBarView = TabBarView.getTabBar(externalDependencies)
            .map({createNavController(tabBar: $0, data: dataProfile)})
        let tabBar: MainTabBarController = dependencies.resolve()
        tabBar.setViewControllers(tabBarView)
        UIView.animate(withDuration: 0.8, animations: { [ weak self] in
            self?.setRoot(tabBar)
        }, completion: {_ in 
            tabBar.hideLoading()
        })
    }
    
    func tabBarSelect(_ item: String) {
        guard let index = tabBarView.firstIndex(where: { $0.tabBarItem.title == item }) else { return }
        if index == selectedTabBarIndex {
            childCoordinators[index].childCoordinators.forEach { $0.onFinish?() }
        }
        selectedTabBarIndex = index
    }
}

private extension MainTabBarCoordinatorImp {
    func createNavController(tabBar: TabBarView, data: IdAccountDataProfileRepresentable?) -> UINavigationController {
        let navigation = tabBar.getNavigation()
        let coordinator = tabBar.getCoordinator()
        navigation.viewControllers = []
        navigation.tabBarItem.title = tabBar.getTitle().localize()
        navigation.tabBarItem.image = UIImage(systemName: tabBar.getImage())
        switch tabBar {
        case .profile:
            let type: NavigationStats = .profile
            if let bindableCoordinator = coordinator as? BindableCoordinator {
                bindableCoordinator
                    .set(type)
                    .set(data)
                    .start()
            }
        case .favourite:
            coordinator.start()
        case .setting:
            if let bindableCoordinator = coordinator as? BindableCoordinator {
                bindableCoordinator
                    .set(data)
                    .start()
            }
        }
        append(child: coordinator)
        return navigation
    }
}

private extension MainTabBarCoordinatorImp {
    struct Dependency: MainTabBarDependencies {
        let external: MainTabBarExternalDependencies
        unowned var coordinator: MainTabBarCoordinator
        let dataBinding = DataBindingObject()
        
        func resolve() -> MainTabBarCoordinator {
            return coordinator
        }
        
        func resolve() -> DataBinding {
            dataBinding
        }
    }
}
