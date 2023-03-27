//
//  StatsGeneralViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import Foundation
import Combine

final class StatsGeneralViewModel {
    private let apiService: ApiClientService
    var state = PassthroughSubject<OutputStats, Never>()
    private let dependencies: StatsGeneralDependency
    private weak var coordinator: StatsGeneralCoordinator?
    private let statsGeneralDataUseCase: StatsGeneralDataUseCase
    
    init(dependencies: StatsGeneralDependency, apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.statsGeneralDataUseCase = dependencies.resolve()
    }
    
    func fetchDataGeneral(account: String){
        state.send(.loading)
        statsGeneralDataUseCase.executeSurvival(account: account) { [weak self] result in
            switch result {
            case .success(let survival):
                self?.state.send(.successSurvival(model: survival))
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
        statsGeneralDataUseCase.executeGamesModes(account: account) { [weak self] result in
            switch result {
            case .success(let gamesMode):
                self?.state.send(.successGamesModes(model: gamesMode))
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
    }
    func saveSurvivalData(survivalData: [SurvivalDTO]) {
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        sessionUser.survival = survivalData
    }
    func saveGamesModeData(gamesModeData: [GamesModesDTO]) {
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        sessionUser.gameModes = gamesModeData
    }
    func backButton() {
        coordinator?.dismiss()
    }
    func goKillsData() {
        coordinator?.performTransition(.goKillsData)
    }
    func goWeapons() {
        coordinator?.performTransition(.goWeapons)
    }
    func goSurvival() {
        coordinator?.performTransition(.goSurvival)
    }
    func goGamesModes() {
        coordinator?.performTransition(.goGamesModes)
    }
}



