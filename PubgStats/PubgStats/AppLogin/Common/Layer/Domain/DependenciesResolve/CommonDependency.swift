//
//  CommonDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 5/4/23.
//

protocol CommonDependency {
    var external: CommonExternalDependency { get }
    func resolve() -> CommonRepository
}
extension CommonDependency {
    func resolve() -> CommonRepository {
        CommonRepositoryImp(dependencies: self)
    }
}
