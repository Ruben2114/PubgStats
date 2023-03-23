//
//  ForgotViewModel.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

final class ForgotViewModel {
    private let dependencies: ForgotDependency
    private var coordinator: ForgotCoordinator?
    
    init(dependencies: ForgotDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
    }
}
