//
//  LoginRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

struct LoginRepositoryImp: LoginRepository {
    private(set) var dataSource: LocalDataProfileService

    func checkName(sessionUser: ProfileEntity, name: String, password: String) -> Bool {
        let result =  dataSource.checkUser(sessionUser: sessionUser, name: name, password: password)
        return result
    }
}

