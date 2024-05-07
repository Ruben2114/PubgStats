//
//  SettingsCoordinatorSpy.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

import PubgStats
import UIKit

final class SettingsCoordinatorSpy: SettingsCoordinator {
    var dataBinding: DataBinding
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var goToDeleteProfile = false
    var goToHelp = false
    
    init() {
        dataBinding = DataBindingObject()
    }
    
    func start() {}
    
    func goDeleteProfile() {
        goToDeleteProfile = true
    }
    
    func goHelp() {
        goToHelp = true
    }
}
