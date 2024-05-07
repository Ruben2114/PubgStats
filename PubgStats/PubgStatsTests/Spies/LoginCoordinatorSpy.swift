//
//  LoginCoordinatorSpy.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import PubgStats
import UIKit

final class LoginCoordinatorSpy: LoginCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var goToProfileCalled = false
    
    func start() {}
    
    func goToProfile(data: IdAccountDataProfileRepresentable) {
        goToProfileCalled = true
    }
}
