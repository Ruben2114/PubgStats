//
//  MainTabBarCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol MainTabBarCoordinator: Coordinator { }

final class MainTabBarCoordinatorImp: MainTabBarCoordinator {
    lazy var dataBinding: DataBinding = dependencies.resolve()
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: MainTabBarExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    private var dataProfile: IdAccountDataProfileRepresentable?
    
    public init(dependencies: MainTabBarExternalDependency, data: IdAccountDataProfileRepresentable) {
        self.externalDependencies = dependencies
        self.dataProfile = data
    }
    
    func start() {
        let profileCoordinator = dependencies.external.profileCoordinator(navigation: dependencies.external.profileNavigationController())
        profileCoordinator.set(dataProfile).start()
        let profile = createNavController(navigation: dependencies.external.profileNavigationController(),
                                           coordinator: profileCoordinator,
                                           title: "profileTabBarItem",
                                           image: "person.circle.fill")
        
        let favourite = createNavController(navigation: dependencies.external.favouriteNavigationController(),
                                           coordinator: dependencies.external.favouriteCoordinator(),
                                           title: "favouriteTabBarItem",
                                           image: "star.circle.fill")
        //TODO: cambiar esto por matches y guide en una totalizator en la view (en favoritos en matches se cambian por la view de noticias)
        let guide = createNavController(navigation: dependencies.external.guideNavigationController(),
                                           coordinator: dependencies.external.guideCoordinator(),
                                           title: "guideTabBarItem",
                                           image: "book.circle.fill")
        
        let settings = createNavController(navigation: dependencies.external.settingsNavigationController(),
                                           coordinator: dependencies.external.settingsCoordinator(),
                                           title: "settingsTabBarItem",
                                           image: "gear.circle.fill")
        
        let tabBar = dependencies.external.tabBarController()
        tabBar.viewControllers = [profile, favourite ,guide ,settings]
        tabBar.tabBar.backgroundColor = .white
    }
    
    func dismiss() {
        dependencies.external.settingsNavigationController().viewControllers = []
        dependencies.external.profileNavigationController().viewControllers = []
        dependencies.external.guideNavigationController().viewControllers = []
        dependencies.external.favouriteNavigationController().viewControllers = []
        childCoordinators.removeAll()
    }
}

private extension MainTabBarCoordinatorImp {
    func createNavController(navigation: UINavigationController, coordinator: Coordinator, title: String, image: String) -> UINavigationController {
        navigation.viewControllers = []
        navigation.tabBarItem.title = title.localize()
        navigation.tabBarItem.image = UIImage(systemName: image)
        coordinator.start()
        append(child: coordinator)
        return navigation
    }
}

private extension MainTabBarCoordinatorImp {
    struct Dependency: MainTabBarDependency {
        let external: MainTabBarExternalDependency
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
