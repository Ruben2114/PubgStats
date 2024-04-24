//
//  SettingsViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

import Foundation
import Combine

enum SettingsState {
    case idle
    case showFields([SettingsField])
    case showErrorDelete
}

final class SettingsViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: SettingsDependencies
    private let stateSubject = CurrentValueSubject<SettingsState, Never>(.idle)
    var state: AnyPublisher<SettingsState, Never>
    private let deleteProfileSubject = PassthroughSubject<IdAccountDataProfileRepresentable, Never>()
    @BindingOptional private var profile: IdAccountDataProfileRepresentable?
    
    init(dependencies: SettingsDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        subscribeDeleteProfilePublisher()
        stateSubject.send(.showFields(SettingsField.allCases))
    }
    
    func deleteProfile() {
        deleteProfileSubject.send(profile ?? DefaultIdAccountDataProfile(id: "", name: "", platform: ""))
    }
    
    func infoDeveloper() {
        //TODO: presentar un bottomSheet con el titulo y el label y listo
        coordinator.goInfoDeveloper()
    }
    
    func goHelp() {
        coordinator.goHelp()
    }
}

private extension SettingsViewModel {
    var coordinator: SettingsCoordinator {
        return dependencies.resolve()
    }
    
    var settingsDataUseCase: SettingsDataUseCase {
        return dependencies.resolve()
    }
}

//MARK: - Subscriptions
private extension SettingsViewModel {
    func subscribeDeleteProfilePublisher() {
        deleteProfilePublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                self?.stateSubject.send(.showErrorDelete)
                self?.subscribeDeleteProfilePublisher()
            default: break
            }
        } receiveValue: { [weak self] _ in
            self?.coordinator.goDeleteProfile()
        }.store(in: &anySubscription)
    }
}

//MARK: - Publishers
private extension SettingsViewModel {
    func deleteProfilePublisher() -> AnyPublisher<Void, Error> {
        return deleteProfileSubject.flatMap { [unowned self] profile in
            self.settingsDataUseCase.deleteProfile(profile: profile).eraseToAnyPublisher()
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}



