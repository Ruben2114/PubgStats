//
//  LoginRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

struct LoginRepositoryImp: LoginRepository {
    private let dataSource: LocalDataProfileService
    init(dependencies: LoginDependency) {
        self.dataSource = dependencies.external.resolve()
    }
    func checkName(sessionUser: ProfileEntity, name: String, password: String) -> Bool {
        let result =  dataSource.checkUser(sessionUser: sessionUser, name: name, password: password)
        return result
    }
}

