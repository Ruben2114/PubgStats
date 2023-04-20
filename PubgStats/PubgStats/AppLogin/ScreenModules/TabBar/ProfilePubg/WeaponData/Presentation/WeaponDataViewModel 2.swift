//
//  WeaponDataViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//
import Combine

final class WeaponDataViewModel {
    private let apiService: ApiClientService
    var state = PassthroughSubject<OutputWeapon, Never>()
    private let dependencies: WeaponDataDependency
    private weak var coordinator: WeaponDataCoordinator?
    private let weaponDataUseCase: WeaponDataUseCase
    var dataKillsDict: [String: Int] = [:]
    
    init(dependencies: WeaponDataDependency, apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.weaponDataUseCase = dependencies.resolve()
    }
    func fetchDataGeneral(account: String) {
        state.send(.loading)
        weaponDataUseCase.execute(account: account) { [weak self] result in
            switch result {
            case .success(let weapon):
                self?.state.send(.success(model: weapon))
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
    }
    func saveSurvivalData(weaponData: [WeaponDTO]) {
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        sessionUser.weapons = weaponData
    }
    func backButton() {
        coordinator?.dismiss()
    }
    func goWeaponItem(weapon: String){
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        sessionUser.weapon = weapon
        coordinator?.performTransition(.goWeapon)
    }
}
