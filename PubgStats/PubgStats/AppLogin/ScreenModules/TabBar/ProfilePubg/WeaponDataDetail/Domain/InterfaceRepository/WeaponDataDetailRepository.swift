//
//  WeaponDataDetailRepository.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 12/4/23.
//

protocol WeaponDataDetailRepository {
    func getDataWeaponDetail(type: NavigationStats) -> [Weapon]?
}
