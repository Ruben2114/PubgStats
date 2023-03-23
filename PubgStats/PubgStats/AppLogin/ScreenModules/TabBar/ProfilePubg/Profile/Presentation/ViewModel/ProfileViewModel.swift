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
    var stateSave = PassthroughSubject<StateController, Never>()
    weak private var coordinator: ProfileCoordinator?
    private let profileDataUseCase: ProfileDataUseCase
    private let dependencies: ProfileDependency
    
    init(dependencies: ProfileDependency,apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.profileDataUseCase = dependencies.resolve()
    }
    
    func dataGeneral(name: String){
        guard let url = URL(string: ApisUrl.generalData(name: name).urlString) else { return }
        apiService.dataPlayer(url: url) { [weak self] (result: Result<PubgPlayer, Error>) in
                switch result {
                case .success(let generalData):
                    self?.state.send(.success(model: generalData))
                case .failure(let error):
                    self?.state.send(.fail(error: "\(error)"))
                }
        }
    }
    //TODO: GUARDAR ID EN CORE DATA
    func saveUser(player: String, account: String) {
        stateSave.send(.loading)
        //profileDataUseCase.execute(name: name, password: password)
        stateSave.send(.success)
    }
    
    func didTapPersonalDataButton() {
        coordinator?.performTransition(.goPersonalData)
    }
    func didTapSettingButton() {
        coordinator?.performTransition(.goSetting)
    }
    func didTapLinkPubgAccountButton() {
        coordinator?.performTransition(.goLinkPubg)
    }
    func didTapStatsgAccountButton() {
        coordinator?.performTransition(.goProfilePubg)
    }
}



