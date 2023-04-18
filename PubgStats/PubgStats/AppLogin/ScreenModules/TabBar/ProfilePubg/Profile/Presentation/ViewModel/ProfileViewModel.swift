//
//  ProfileViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine

final class ProfileViewModel {
    var state = PassthroughSubject<OutputPlayer, Never>()
    private weak var coordinator: ProfileCoordinator?
    private let profileDataUseCase: ProfileDataUseCase
    private let dependencies: ProfileDependency
    private let sessionUser: ProfileEntity
    let items: [[ProfileField]] = [
        [ProfileField.name, ProfileField.email, ProfileField.password, ProfileField.image],
        [ProfileField.login, ProfileField.stats, ProfileField.delete]
    ]
    init(dependencies: ProfileDependency) {
        self.sessionUser = dependencies.external.resolve()
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
    func changeValue(sessionUser: ProfileEntity,_ value: String, type: String) {
        profileDataUseCase.changeValue(sessionUser: sessionUser,value, type: type)
    }
    func changeImage(sessionUser: ProfileEntity, image: Data) {
        profileDataUseCase.changeImage(sessionUser: sessionUser, image: image)
    }
    func checkName(name: String) -> Bool {
        let check = profileDataUseCase.check(name,type: "name")
        return check
    }
    func checkEmail(email: String) -> Bool {
        let check = profileDataUseCase.check(email,type: "email")
        return check
    }
    func backButton() {
        coordinator?.performTransition(.goBackView)
    }
    func didTapStatsgAccountButton() {
        coordinator?.performTransition(.goStatsGeneral)
    }
    func deletePubgAccount(){
        profileDataUseCase.deletePubgAccount(sessionUser: sessionUser)
    }
}



