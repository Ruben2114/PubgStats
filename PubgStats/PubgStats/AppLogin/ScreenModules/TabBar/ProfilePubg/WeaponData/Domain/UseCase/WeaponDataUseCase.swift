//
//  WeaponDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

protocol WeaponDataUseCase {
    func execute(account: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void)
}

struct WeaponDataUseCaseImp: WeaponDataUseCase {
    private(set) var weaponDataRepository: WeaponDataRepository

    func execute(account: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void){
        weaponDataRepository.fetchWeaponData(account: account, completion: completion)
    }
}