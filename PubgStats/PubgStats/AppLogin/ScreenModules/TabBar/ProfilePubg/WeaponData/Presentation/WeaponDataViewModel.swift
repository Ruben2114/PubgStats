//
//  WeaponDataViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//
import Combine
import Foundation

final class WeaponDataViewModel {
    private let apiService: ApiClientService
    var state = PassthroughSubject<OutputWeapon, Never>()
    private let dependencies: WeaponDataDependency
    private weak var coordinator: WeaponDataCoordinator?
    private let weaponDataUseCase: WeaponDataUseCase
    var weaponType: [String] = []
    
    init(dependencies: WeaponDataDependency, apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.weaponDataUseCase = dependencies.resolve()
    }
    func getDataWeapon() -> [Weapon]? {
        guard let type = coordinator?.type else {return nil}
        let weaponData = weaponDataUseCase.getDataWeapon(type: type)
        return weaponData
    }
    func searchId() -> String? {
        guard let type = coordinator?.type else {return nil}
        if type == .favourite{
            return ""
            //sessionUser.accountFavourite
        } else {
            return ""
            //sessionUser.account
        }
    }
    func viewDidLoad() {
        state.send(.loading)
        let weaponData = getDataWeapon()
        let userDefaults = UserDefaults.standard
        guard userDefaults.bool(forKey: "reload") == true else{
            fetchData()
            userDefaults.set(true, forKey: "reload")
            return
        }
        guard let _ = weaponData?.first?.weapon ?? weaponData?.first?.weaponFav else {
            fetchData()
            return
        }
        getNameWeapon(model: weaponData)
        self.state.send(.success)
    }
    func fetchData(){
        guard let id = searchId(), !id.isEmpty else {return}
        //TODO: poner opcion platform con un boton y un menu con steam o xbox
        weaponDataUseCase.execute(account: id, platform: "steam") { [weak self] result in
            switch result {
            case .success(let weapon):
                self?.saveWeaponData(weaponData: weapon)
                self?.getWeapons(weaponData: weapon)
                self?.state.send(.success)
            case .failure(_):
                self?.state.send(.fail(error: "fetchDataWeaponError".localize()))
            }
        }
    }
    func saveWeaponData(weaponData: WeaponDTO) {
        guard let type = coordinator?.type else {return}
        weaponDataUseCase.saveWeaponData(weaponData: weaponData, type: type)
    }
    func getNameWeapon(model: [Weapon]?){
        if let weapon = model {
            var modes = weapon.compactMap { $0.name }
            modes.sort { $0 < $1 }
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
        coordinator?.performTransition(.goWeapon)
    }
}
