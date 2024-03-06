//
//  SceneDelegate.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var dependencies = AppDependencies(window: window)
    lazy var childCoordinators: [Coordinator] = []
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //TODO: cambiarlo al appdelegate!! importante
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        let user = dependencies.resolve().getAnyProfile()
        window?.rootViewController = user == nil ? dependencies.loginNavigationController() : dependencies.tabBarController()
        let rootCoordinator = user == nil ? dependencies.loginCoordinator() : dependencies.mainTabBarCoordinator(data: user!)
        rootCoordinator.start()
        childCoordinators.append(rootCoordinator)
    }
    
    func changeRootViewCoordinator(data: IdAccountDataProfileRepresentable? = nil, goToProfile: Bool = false) {
        if !goToProfile {
            childCoordinators.first?.dismiss()
        }
        childCoordinators.removeAll()
        let rootCoordinator = goToProfile ? dependencies.mainTabBarCoordinator(data: data) : dependencies.loginCoordinator()
        rootCoordinator.start()
        childCoordinators.append(rootCoordinator)
        
        UIView.transition(with: window!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.window?.rootViewController = goToProfile ? self?.dependencies.tabBarController() : self?.dependencies.loginNavigationController()
                          },
                          completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

