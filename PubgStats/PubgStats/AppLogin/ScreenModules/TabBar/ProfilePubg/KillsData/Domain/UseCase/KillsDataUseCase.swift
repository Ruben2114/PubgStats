//
//  KillsDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol KillsDataUseCase {
    func getGamesModes(for sessionUser: ProfileEntity) -> [GamesModes]?
}

struct KillsDataUseCaseImp: KillsDataUseCase {
    private let killsDataRepository: KillsDataRepository
    init(dependencies: KillsDataDependency) {
        self.killsDataRepository = dependencies.resolve()
    }
    func getGamesModes(for sessionUser: ProfileEntity) -> [GamesModes]?{
        killsDataRepository.getGamesModes(for: sessionUser)
    }
}
