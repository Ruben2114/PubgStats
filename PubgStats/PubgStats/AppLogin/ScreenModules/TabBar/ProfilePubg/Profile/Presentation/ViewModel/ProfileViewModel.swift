//
//  ProfileViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine

final class ProfileViewModel {
    private let apiService: ApiClientService
    var state = PassthroughSubject<OutputPlayer, Never>()
    private weak var coordinator: ProfileCoordinator?
    private let profileDataUseCase: ProfileDataUseCase
    private let dependencies: ProfileDependency
    
    init(dependencies: ProfileDependency,apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.profileDataUseCase = dependencies.resolve()
    }
    
    func dataGeneral(name: String){
        state.send(.loading)
        profileDataUseCase.fetchPlayerData(name: name) { [weak self] result in
            switch result {
            case .success(let player):
                self?.state.send(.success(model: player))
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
    }
    func saveUser(player: String, account: String) {
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        profileDataUseCase.execute(sessionUser: sessionUser, player: player, account: account)
    }
    func logOut() {
        coordinator?.performTransition(.goLogOut)
    }
    func didTapPersonalDataButton() {
        coordinator?.performTransition(.goPersonalData)
    }
    func didTapSettingButton() {
        coordinator?.performTransition(.goSetting)
    }
    func didTapStatsgAccountButton() {
        coordinator?.performTransition(.goStatsGeneral)
    }
}



