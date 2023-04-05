//
//  WeaponDataRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

struct WeaponDataRepositoryImp: WeaponDataRepository {
    let remoteData: RemoteService
    
    func fetchWeaponData(account: String, completion: @escaping (Result<WeaponDTO, Error>) -> Void) {
        remoteData.getWeaponData(account: account, completion: completion)
    }
}
