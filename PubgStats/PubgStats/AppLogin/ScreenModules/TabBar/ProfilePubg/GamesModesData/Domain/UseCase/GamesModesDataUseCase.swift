//
//  GamesModesDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol GamesModesDataUseCase {
    func getGamesModes(type: NavigationStats) -> [GamesModes]?
}

struct GamesModesDataUseCaseImp: GamesModesDataUseCase {
    private let gamesModesDataRepository: GamesModesDataRepository
    init(dependencies: GamesModesDataDependency) {
        self.gamesModesDataRepository = dependencies.resolve()
    }
    func getGamesModes(type: NavigationStats) -> [GamesModes]?{
        gamesModesDataRepository.getGamesModes(type: type)
    }
}
