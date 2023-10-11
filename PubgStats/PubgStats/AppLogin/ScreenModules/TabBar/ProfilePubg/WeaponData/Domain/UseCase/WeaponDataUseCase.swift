//
//  WeaponDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

protocol WeaponDataUseCase {
    func execute(account: String, platform: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void)
    func saveWeaponData(sessionUser: ProfileEntity, weaponData: WeaponDTO, type: NavigationStats)
    func getDataWeapon(for sessionUser: ProfileEntity, type: NavigationStats) -> [Weapon]?
}

struct WeaponDataUseCaseImp: WeaponDataUseCase {
    private let weaponDataRepository: WeaponDataRepository
    init(dependencies: WeaponDataDependency) {
        self.weaponDataRepository = dependencies.resolve()
    }
    func execute(account: String, platform: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void){
        weaponDataRepository.fetchWeaponData(account: account, platform: platform, completion: completion)
    }
    func saveWeaponData(sessionUser: ProfileEntity, weaponData: WeaponDTO,type: NavigationStats) {
        weaponDataRepository.saveWeaponData(sessionUser: sessionUser, weaponData: weaponData, type: type)
    }
    func getDataWeapon(for sessionUser: ProfileEntity, type: NavigationStats) -> [Weapon]? {
        weaponDataRepository.getDataWeapon(for: sessionUser, type: type)
    }
}
