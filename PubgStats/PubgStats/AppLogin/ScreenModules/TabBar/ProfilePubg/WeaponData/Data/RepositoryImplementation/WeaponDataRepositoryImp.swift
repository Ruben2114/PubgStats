//
//  WeaponDataRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

struct WeaponDataRepositoryImp: WeaponDataRepository {
    private let remoteData: RemoteService
    private let dataSource: LocalDataProfileService
    init(dependencies: WeaponDataDependency) {
        self.remoteData = dependencies.external.resolve()
        self.dataSource = dependencies.external.resolve()
    }
    func fetchWeaponData(account: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void) {
        remoteData.getWeaponData(account: account, completion: completion)
    }
    func saveWeaponData(sessionUser: ProfileEntity, weaponData: WeaponDTO, type: NavigationStats) {
        dataSource.saveWeaponData(sessionUser: sessionUser, weaponData: weaponData, type: type)
    }
    func getDataWeapon(for sessionUser: ProfileEntity, type: NavigationStats) -> [Weapon]? {
        dataSource.getDataWeaponDetail(for: sessionUser, type: type)
    }
}
