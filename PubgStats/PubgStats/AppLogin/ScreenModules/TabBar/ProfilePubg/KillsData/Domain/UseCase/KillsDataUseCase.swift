//
//  KillsDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol KillsDataUseCase {
    func getGamesModes(type: NavigationStats) -> [GamesModes]?
}

struct KillsDataUseCaseImp: KillsDataUseCase {
    private let killsDataRepository: KillsDataRepository
    init(dependencies: KillsDataDependency) {
        self.killsDataRepository = dependencies.resolve()
    }
    func getGamesModes(type: NavigationStats) -> [GamesModes]?{
        killsDataRepository.getGamesModes(type: type)
    }
}
