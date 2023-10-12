//
//  GamesModesDataViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

final class GamesModesDataViewModel {
    private weak var coordinator: GamesModesDataCoordinator?
    private let gamesModesDataUseCase: GamesModesDataUseCase
    var nameGamesModes: [String] = []
    
    init(dependencies: GamesModesDataDependency) {
        self.coordinator = dependencies.resolve()
        self.gamesModesDataUseCase = dependencies.resolve()
    }
    func getGamesModes() -> [GamesModes]?{
        guard let type = coordinator?.type else {return nil}
        let gamesModesData = gamesModesDataUseCase.getGamesModes(type: type)
        return gamesModesData
    }
    func fetchDataGamesModes() {
        let dataGamesMode = getGamesModes()
        if let gamesModes = dataGamesMode {
            let modes = gamesModes.compactMap { $0.mode }
            nameGamesModes = modes
        }
    }
    func goGameMode(gameMode: String){
        coordinator?.performTransition(.goGameMode)
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
