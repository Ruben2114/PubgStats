//
//  ProfileRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

struct ProfileRepositoryImp: ProfileRepository {
    var dataSource: LocalDataProfileService

    func saveProfileModel(profile: ProfileModel) async -> Result<Bool, ProfileError> {
        return await dataSource.save(profile: profile)
    }
}
