//
//  StatsGeneralViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import Foundation
import Combine

final class StatsGeneralViewModel {
    var state = PassthroughSubject<OutputStats, Never>()
    private let dependencies: StatsGeneralDependency
    private weak var coordinator: StatsGeneralCoordinator?
    private let statsGeneralDataUseCase: StatsGeneralDataUseCase
    private let sessionUser: ProfileEntity
    init(dependencies: StatsGeneralDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.sessionUser = dependencies.external.resolve()
        self.statsGeneralDataUseCase = dependencies.resolve()
    }
    func viewDidLoad() {
        state.send(.loading)
        guard let name = searchData()[1], !name.isEmpty else {return}
        state.send(.getName(model: name))
        guard let type = coordinator?.type else {return}
        let survivalData = statsGeneralDataUseCase.getSurvival(for: sessionUser, type: type)
        let gamesModesData = statsGeneralDataUseCase.getGamesModes(for: sessionUser, type: type)
        guard let _ = survivalData?.survival ?? survivalData?.survivalFav,
              let _ = gamesModesData?.first?.gamesMode ?? gamesModesData?.first?.gamesModeFav
        else {
            fetchData()
            return
        }
        state.send(.getSurvival(model: survivalData))
        state.send(.getGamesMode(model: gamesModesData))
        state.send(.success)
    }
    func fetchData() {
        let dispatchGroup = DispatchGroup()
        guard let id = searchData()[0], !id.isEmpty else {return}
        guard let type = coordinator?.type else {return}
        dispatchGroup.enter()
        statsGeneralDataUseCase.executeSurvival(account: id) { [weak self] result in
            switch result {
            case .success(let survival):
                self?.state.send(.successSurvival(model: survival))
                guard let user = self?.sessionUser else{return}
                self?.statsGeneralDataUseCase.saveSurvival(sessionUser: user, survivalData: [survival], type: type)
                dispatchGroup.leave()
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
        dispatchGroup.enter()
        statsGeneralDataUseCase.executeGamesModes(account: id) { [weak self] result in
            switch result {
            case .success(let gamesMode):
                self?.state.send(.successGamesModes(model: gamesMode))
                guard let user = self?.sessionUser else{return}
                self?.statsGeneralDataUseCase.saveGamesModeData(sessionUser: user, gamesModeData: gamesMode, type: type)
                dispatchGroup.leave()
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.state.send(.success)
        }
    }
    func searchData() -> [String?] {
        guard let type = coordinator?.type else {return [nil]}
        if type == .favourite{
            return [sessionUser.accountFavourite, sessionUser.nameFavourite]
        } else {
            return [sessionUser.account, sessionUser.player]
        }
    }
    func reload(){
        //TODO: falta fetch de weapon o borrar los datos de weapon
        fetchData()
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



