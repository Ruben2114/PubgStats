//
//  RegisterRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

struct RegisterRepositoryImp: RegisterRepository {
    var dataSource: LocalDataProfileService

    func saveProfileModel(name: String, password: String ,email: String) {
        return dataSource.save(name: name, password: password , email: email)
    }
}
