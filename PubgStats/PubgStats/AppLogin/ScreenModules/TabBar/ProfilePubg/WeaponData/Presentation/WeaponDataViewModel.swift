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
    private let sessionUser: ProfileEntity
    var weaponType: [String] = []
    
    init(dependencies: WeaponDataDependency, apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
        self.dependencies = dependencies
        self.sessionUser = dependencies.external.resolve()
        self.coordinator = dependencies.resolve()
        self.weaponDataUseCase = dependencies.resolve()
    }
    
    func bind() {
        state.send(.loading)
        let weaponData = getDataWeapon(for: sessionUser)
        guard let id = sessionUser.accountFavourite, !id.isEmpty else {return}
        guard let _ = weaponData?.first?.weapon ?? weaponData?.first?.weaponFav else {
            weaponDataUseCase.execute(account: id) { [weak self] result in
                switch result {
                case .success(let weapon):
                    guard let user = self?.sessionUser else {return}
                    self?.saveWeaponData(sessionUser: user, weaponData: weapon)
                    self?.getWeapons(weaponData: weapon)
                    self?.state.send(.success)
                case .failure(let error):
                    self?.state.send(.fail(error: "\(error)"))
                }
            }
            return
        }
        getNameWeapon(for: sessionUser, model: weaponData)
        self.state.send(.success)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func saveWeaponData(sessionUser: ProfileEntity, weaponData: WeaponDTO) {
        guard let type = coordinator?.type else {return}
        weaponDataUseCase.saveWeaponData(sessionUser: sessionUser, weaponData: weaponData, type: type)
    }
    func getDataWeapon(for sessionUser: ProfileEntity) -> [Weapon]? {
        guard let type = coordinator?.type else {return nil}
        let weaponData = weaponDataUseCase.getDataWeapon(for: sessionUser, type: type)
        return weaponData
    }
    func getNameWeapon(for sessionUser: ProfileEntity, model: [Weapon]?){
        if let weapon = model {
            let modes = weapon.compactMap { $0.name }
            weaponType = modes
        }
    }
    func getWeapons(weaponData: WeaponDTO) {
        for data in weaponData.data.attributes.weaponSummaries.keys {
            weaponType.append(data)
        }
        weaponType.sort { $0 < $1 }
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
