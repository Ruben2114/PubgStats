//
//  RegisterRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

struct RegisterRepositoryImp: RegisterRepository {
    var dataSource: LocalDataProfileService

    func saveProfileModel(profile: Profile) {
        return dataSource.save(profile: profile)
    }
}
