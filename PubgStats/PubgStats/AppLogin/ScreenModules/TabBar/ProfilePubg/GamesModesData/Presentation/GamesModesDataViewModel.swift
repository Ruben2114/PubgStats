//
//  GamesModesDataViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

final class GamesModesDataViewModel {
    private let dependencies: GamesModesDataDependency
    private weak var coordinator: GamesModesDataCoordinator?
    private let gamesModesDataUseCase: GamesModesDataUseCase
    let sessionUser: ProfileEntity
    var nameGamesModes: [String] = []
    
    init(dependencies: GamesModesDataDependency) {
        self.sessionUser = dependencies.external.resolve()
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.gamesModesDataUseCase = dependencies.resolve()
    }
    func getGamesModes(for sessionUser: ProfileEntity) -> [GamesModes]?{
        if coordinator?.navigation == dependencies.external.profileNavigationController(){
            let gamesModesData = gamesModesDataUseCase.getGamesModes(for: sessionUser, type: .profile)
            return gamesModesData
        }else {
            let gamesModesData = gamesModesDataUseCase.getGamesModes(for: sessionUser, type: .favourite)
            return gamesModesData
        }
    }
    func fetchDataGamesModes() {
        let dataGamesMode = getGamesModes(for: sessionUser)
        if let gamesModes = dataGamesMode {
            let modes = gamesModes.compactMap { $0.mode }
            nameGamesModes = modes
        }
        sessionUser.gameModesDetail = dataGamesMode
    }
    func goGameMode(gameMode: String){
        sessionUser.gameMode = gameMode
        coordinator?.performTransition(.goGameMode)
    }
   
    func backButton() {
        coordinator?.dismiss()
    }
}
