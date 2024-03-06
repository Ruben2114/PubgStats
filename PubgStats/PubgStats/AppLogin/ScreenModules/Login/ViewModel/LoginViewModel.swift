//
//  LoginViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation
import Combine

enum LoginState {
    case idle
    case sendInfoProfile(IdAccountDataProfileRepresentable)
    case sendInfoProfileError
    case showLoading
}

final class LoginViewModel {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: LoginDependencies
    private let stateSubject = CurrentValueSubject<LoginState, Never>(.idle)
    var state: AnyPublisher<LoginState, Never>
    private let getAccountProfileSubject = PassthroughSubject<(String, String), Never>()
    
    init(dependencies: LoginDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        subscribeDataGeneralPublisher()
    }
    
    func goToProfile(data: IdAccountDataProfileRepresentable) {
        coordinator.goToProfile(data: data)
    }
    
    func checkPlayer(player: String, platform: String) {
        stateSubject.send(.showLoading)
        getAccountProfileSubject.send((player, platform))
    }
}

private extension LoginViewModel {
    var coordinator: LoginCoordinator {
        return dependencies.resolve()
    }
    var profileDataUseCase: LoginDataUseCase {
        return dependencies.resolve()
    }
}

//MARK: - Subscriptions
private extension LoginViewModel {
    func subscribeDataGeneralPublisher() {
        dataGeneralPublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                self?.stateSubject.send(.sendInfoProfileError)
                self?.subscribeDataGeneralPublisher()
            default: break
            }
        } receiveValue: { [weak self] data in
            self?.stateSubject.send(.sendInfoProfile(data))
        }.store(in: &anySubscription)
    }
}

//MARK: - Publishers

private extension LoginViewModel {
    func dataGeneralPublisher() -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        return getAccountProfileSubject.flatMap { [unowned self] name, platform in
            self.profileDataUseCase.fetchPlayerData(name: name, platform: platform)
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
