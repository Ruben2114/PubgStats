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
    func fetchWeaponData(account: String, platform: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void) {
        
    }
    
    func saveWeaponData(weaponData: WeaponDTO, type: NavigationStats) {
        
    }
    
    func getDataWeapon(type: NavigationStats) -> [Weapon]? {
        return []
    }
}
