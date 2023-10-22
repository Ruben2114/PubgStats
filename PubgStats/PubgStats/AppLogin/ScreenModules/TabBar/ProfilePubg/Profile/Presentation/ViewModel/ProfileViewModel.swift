//
//  ProfileViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine

enum ProfileState {
    case idle
    case sendGamesMode(GamesModesDataProfileRepresentable)
    case sendGamesModeError
    case showLoading //TODO: ver donde poner la pantalla de carga
}

final class ProfileViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: ProfileDependency
    private let stateSubject = CurrentValueSubject<ProfileState, Never>(.idle)
    var state: AnyPublisher<ProfileState, Never>
    private let getGamesModeSubject = PassthroughSubject<IdAccountDataProfileRepresentable, Never>()
    @BindingOptional private var dataProfile: IdAccountDataProfileRepresentable?
  
    init(dependencies: ProfileDependency) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        guard let representable = dataProfile else { return }
        subscribeGamesModePublisher()
        getGamesModeSubject.send(representable)
    }
   
    func backButton() {
        coordinator.performTransition(.goBackView)
    }
    func didTapStatsgAccountButton() {
        coordinator.performTransition(.goStatsGeneral)
    }
}

private extension ProfileViewModel {
    var coordinator: ProfileCoordinator {
        return dependencies.resolve()
    }
    
    var profileDataUseCase: ProfileDataUseCase {
        return dependencies.resolve()
    }
}


//MARK: - Subscriptions
private extension ProfileViewModel {
    func subscribeGamesModePublisher() {
        dataGamesModePublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                self?.stateSubject.send(.sendGamesModeError)
                self?.subscribeGamesModePublisher()
            default: break
            }
        } receiveValue: { [weak self] data in
            self?.stateSubject.send(.sendGamesMode(data))
        }.store(in: &anySubscription)
    }
}

//MARK: - Publishers

private extension ProfileViewModel {
    func dataGamesModePublisher() -> AnyPublisher<GamesModesDataProfileRepresentable, Error> {
        return getGamesModeSubject.flatMap { [unowned self] data in
            self.profileDataUseCase.fetchGamesModeData(name: data.name, account: data.id, platform: data.platform)
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}




