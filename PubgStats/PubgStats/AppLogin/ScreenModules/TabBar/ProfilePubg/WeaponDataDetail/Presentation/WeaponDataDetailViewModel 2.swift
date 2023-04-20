//
//  WeaponDataDetailViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

final class WeaponDataDetailViewModel {
    private weak var coordinator: WeaponDataDetailCoordinator?
    init(dependencies: WeaponDataDetailDependency) {
        self.coordinator = dependencies.resolve()
    }
    
    func backButton() {
        coordinator?.dismiss()
    }
}
