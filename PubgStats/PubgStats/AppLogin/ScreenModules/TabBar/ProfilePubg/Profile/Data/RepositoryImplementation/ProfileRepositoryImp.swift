//
//  ProfileRepositoryImp.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation
import Combine

struct ProfileRepositoryImp: ProfileRepository {
    private let dataSource: LocalDataProfileService
    private let remoteData: RemoteService
    init(dependencies: ProfileDependency) {
        self.dataSource = dependencies.external.resolve()
        self.remoteData = dependencies.external.resolve()
    }
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<PubgPlayerDTO, Error> {
        remoteData.getPlayerData(name: name, platform: platform).eraseToAnyPublisher()
    }
}
