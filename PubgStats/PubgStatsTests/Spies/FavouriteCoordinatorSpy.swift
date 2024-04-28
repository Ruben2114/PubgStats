//
//  FavouriteCoordinatorSpy.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

import PubgStats
import UIKit

final class FavouriteCoordinatorSpy: FavouriteCoordinator {
    var dataBinding: DataBinding
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var goToProfile = false
    
    init() {
        dataBinding = DataBindingObject()
    }
    
    func start() {}
    
    func goToProfile(data: IdAccountDataProfileRepresentable?) {
        goToProfile = true
    }
}
