//
//  MatchesCoordinatorSpy.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 27/4/24.
//

import PubgStats
import UIKit

final class MatchesCoordinatorSpy: MatchesCoordinator {
    var dataBinding: DataBinding
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var goToBack = false
    
    init() {
        dataBinding = DataBindingObject()
    }
    
    func start() {}
    
    func goBack() {
        goToBack = true
    }
}
