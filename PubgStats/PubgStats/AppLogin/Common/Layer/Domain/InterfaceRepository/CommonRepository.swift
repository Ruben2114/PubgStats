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
    private var dataSource: LocalDataProfileService
    init(dataSource: LocalDataProfileService) {
        self.dataSource = dataSource
    }
    /*
    init(dependencies: CommonDependency) {
        self.dataSource = dependencies.external.resolve()
    }
     */
    func checkName(name: String) -> Bool {
        let result =  dataSource.checkIfNameExists(name: name)
        return result
    }
    func checkEmail(email: String) -> Bool {
        let result =  dataSource.checkIfEmailExists(email: email)
        return result
    }
}
