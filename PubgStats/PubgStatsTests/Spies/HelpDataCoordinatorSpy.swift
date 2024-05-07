//
//  HelpDataCoordinatorSpy.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

import PubgStats
import UIKit

final class HelpDataCoordinatorSpy: HelpDataCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var goToBack = false
    
    init() {}
    
    func start() {}
    
    func goBack() {
        goToBack = true
    }
}
