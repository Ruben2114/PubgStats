//
//  WeaponDataDetailRepositoryImp.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 12/4/23.
//

struct WeaponDataDetailRepositoryImp: WeaponDataDetailRepository {
    private let dataSource: LocalDataProfileService
    
    init(dependencies: WeaponDataDetailDependency) {
        self.dataSource = dependencies.external.resolve()
    }
    
    func getDataWeaponDetail(type: NavigationStats) -> [Weapon]? {
        return []
    }
}
