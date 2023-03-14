//
//  ProfileRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

struct ProfileRepositoryImp: ProfileRepository {
    var dataSource: LocalDataProfileService

    func saveProfileModel(profile: Profile) {
        return dataSource.save(profile: profile)
    }
}
