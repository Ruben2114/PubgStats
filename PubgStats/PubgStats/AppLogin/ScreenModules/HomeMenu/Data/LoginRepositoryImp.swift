//
//  LoginRepositoryImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

struct LoginRepositoryImp: LoginRepository {
    private(set) var dataSource: LocalDataProfileService

    func getProfile(name: String, password: String) async throws -> Profile? {
        let result = try await dataSource.get(name: name, password: password)
        return result
    }
}

