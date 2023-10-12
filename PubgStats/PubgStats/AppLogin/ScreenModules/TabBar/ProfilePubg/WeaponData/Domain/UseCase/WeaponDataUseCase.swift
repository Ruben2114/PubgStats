//
//  WeaponDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

protocol WeaponDataUseCase {
    func execute(account: String, platform: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void)
    func saveWeaponData(weaponData: WeaponDTO, type: NavigationStats)
    func getDataWeapon(type: NavigationStats) -> [Weapon]?
}

struct WeaponDataUseCaseImp: WeaponDataUseCase {
    private let weaponDataRepository: WeaponDataRepository
    init(dependencies: WeaponDataDependency) {
        self.weaponDataRepository = dependencies.resolve()
    }
    func execute(account: String, platform: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void){
        weaponDataRepository.fetchWeaponData(account: account, platform: platform, completion: completion)
    }
    func saveWeaponData(weaponData: WeaponDTO,type: NavigationStats) {
        weaponDataRepository.saveWeaponData(weaponData: weaponData, type: type)
    }
    func getDataWeapon(type: NavigationStats) -> [Weapon]? {
        weaponDataRepository.getDataWeapon(type: type)
    }
}
