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
    private let sessionUser: ProfileEntity
    init(dependencies: StatsGeneralDependency, apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.sessionUser = dependencies.external.resolve()
        self.statsGeneralDataUseCase = dependencies.resolve()
    }
    func fetchDataGeneral(account: String) {
        state.send(.loading)
        var successCount = 0
        statsGeneralDataUseCase.executeSurvival(account: account) { [weak self] result in
            switch result {
            case .success(let survival):
                self?.state.send(.successSurvival(model: survival))
                successCount += 1
                if successCount == 2 {
                    self?.state.send(.success)
                }
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
        statsGeneralDataUseCase.executeGamesModes(account: account) { [weak self] result in
            switch result {
            case .success(let gamesMode):
                self?.state.send(.successGamesModes(model: gamesMode))
                successCount += 1
                if successCount == 2 {
                    self?.state.send(.success)
                }
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
    }
    func navigation() -> NavigationStats? {
        guard let type: NavigationStats = coordinator?.dataBinding.get() else {return nil}
        return type
    }
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO], type: NavigationStats){
        statsGeneralDataUseCase.saveSurvival(sessionUser: sessionUser, survivalData: survivalData, type: type)
    }
    func getSurvival(for sessionUser: ProfileEntity, type: NavigationStats) -> Survival?{
        statsGeneralDataUseCase.getSurvival(for: sessionUser, type: type)
    }
    func getGamesModes(for sessionUser: ProfileEntity, type: NavigationStats) -> [GamesModes]?{
        statsGeneralDataUseCase.getGamesModes(for: sessionUser, type: type)
    }
    
    func saveGamesModeData(sessionUser: ProfileEntity, gamesModeData: [GamesModesDTO], type: NavigationStats) {
        statsGeneralDataUseCase.saveGamesModeData(sessionUser: sessionUser, gamesModeData: gamesModeData, type: type)
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



