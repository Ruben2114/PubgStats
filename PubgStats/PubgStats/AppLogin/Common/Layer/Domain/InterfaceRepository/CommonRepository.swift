//
//  CommonRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 4/4/23.
//

protocol CommonRepository {
    func checkName(name: String) -> Bool
    func checkEmail(email: String) -> Bool
}

struct CommonRepositoryImp: CommonRepository {
    private let dataSource: LocalDataProfileService
    
    init(dependencies: CommonExternalDependency) {
        self.dataSource = dependencies.resolve()
    }
    
    func checkName(name: String) -> Bool {
        let result =  dataSource.checkIfNameExists(name: name)
        return result
    }
    func checkEmail(email: String) -> Bool {
        let result =  dataSource.checkIfEmailExists(email: email)
        return result
    }
}
