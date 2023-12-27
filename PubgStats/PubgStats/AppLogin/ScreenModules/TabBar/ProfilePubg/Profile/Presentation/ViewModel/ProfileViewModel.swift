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
    case showErrorPlayerDetails
    case hideLoading
}

final class ProfileViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: ProfileDependency
    private let stateSubject = CurrentValueSubject<ProfileState, Never>(.idle)
    var state: AnyPublisher<ProfileState, Never>
    private let getPlayerDetailsSubject = PassthroughSubject<IdAccountDataProfileRepresentable, Never>()
    @BindingOptional private var dataProfile: IdAccountDataProfileRepresentable?
  
    init(dependencies: ProfileDependency) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        subscribePlayerDetailsPublisher()
        getPlayerDetailsSubject.send(dataProfile ?? DefaultIdAccountDataProfile(id: "", name: "", platform: ""))
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
    func subscribePlayerDetailsPublisher() {
        playerDetailsPublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                self?.stateSubject.send(.showErrorPlayerDetails)
                self?.stateSubject.send(.hideLoading)
                self?.subscribePlayerDetailsPublisher()
            default: break
            }
        } receiveValue: { [weak self] data in
            //TODO: aqui ya tengo toda la info ahora seria ir enviando a las vistas la información
            self?.stateSubject.send(.sendGamesMode(data.infoGamesModes))
            self?.stateSubject.send(.hideLoading)
        }.store(in: &anySubscription)
    }
}

//MARK: - Publishers

private extension ProfileViewModel {
    func playerDetailsPublisher() -> AnyPublisher<PlayerDetailsRepresentable, Error> {
        return getPlayerDetailsSubject.flatMap { [unowned self] data in
            self.profileDataUseCase.fetchPlayerDetails(data)
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
