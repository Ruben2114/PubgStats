//
//  SettingsDataRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

struct SettingsDataRepositoryImp : SettingsDataRepository {
    private let dataSource: LocalDataProfileService
    
    init(dependencies: SettingsDependency) {
        self.dataSource = dependencies.external.resolve()
    }
    
    func deleteProfile(sessionUser: ProfileEntity) {
        dataSource.deleteProfile(sessionUser)
    }
}
