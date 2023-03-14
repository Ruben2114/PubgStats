//
//  LoginRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

struct LoginRepositoryImp: LoginRepository {
    private(set) var dataSource: LocalDataProfileService

    func checkName(name: String, password: String) -> Bool {
        let result =  dataSource.checkUser(name: name, password: password)
        return result
    }
}

