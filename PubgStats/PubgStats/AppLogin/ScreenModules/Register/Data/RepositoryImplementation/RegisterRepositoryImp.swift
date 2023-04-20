//
//  RegisterRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

struct RegisterRepositoryImp: RegisterRepository {
    private let dataSource: LocalDataProfileService
    init(dependencies: RegisterDependency) {
        self.dataSource = dependencies.external.resolve()
    }
    func saveProfileModel(name: String, password: String ,email: String) -> Bool {
        dataSource.save(name: name, password: password , email: email)
    }
}
