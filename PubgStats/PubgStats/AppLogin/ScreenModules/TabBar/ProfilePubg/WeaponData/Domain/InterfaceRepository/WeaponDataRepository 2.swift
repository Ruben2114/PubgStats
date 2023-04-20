//
//  WeaponDataRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

protocol WeaponDataRepository {
    func fetchWeaponData(account: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void)
}
