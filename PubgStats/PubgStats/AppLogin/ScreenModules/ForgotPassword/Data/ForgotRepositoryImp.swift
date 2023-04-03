//
//  ForgotRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 3/4/23.
//

struct ForgotRepositoryImp: ForgotRepository {
    private(set) var dataSource: LocalDataProfileService

    func check(name: String, email: String) -> Bool {
        let result =  dataSource.checkUserAndChangePassword(name: name, email: email)
        return result
    }
}
