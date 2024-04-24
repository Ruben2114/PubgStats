//
//  PersonalDataViewModel.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

final class PersonalDataViewModel {
    private let dependencies: PersonalDataDependency
    private weak var coordinator: PersonalDataCoordinator?
    
    init(dependencies: PersonalDataDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
    }
    func backButton() {
        coordinator?.dismiss()
    }
    func goPasswordData() {
        print("password")
    }
    func goImageData() {
        print("image")
    }
    func goPubgAccount() {
        print("account")
    }
}
