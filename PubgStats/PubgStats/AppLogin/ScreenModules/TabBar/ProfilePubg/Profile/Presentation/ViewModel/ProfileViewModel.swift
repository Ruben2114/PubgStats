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
}

final class ProfileViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: ProfileDependency
    private let stateSubject = CurrentValueSubject<ProfileState, Never>(.idle)
    var state: AnyPublisher<ProfileState, Never>
    private let getAccountProfilSubject = PassthroughSubject<(String, String), Never>()
    @BindingOptional private var dataProfile: DefaultIdAccountDataProfileRepresentable?
  
    let items: [[ProfileField]] = [
        [ProfileField.name, ProfileField.email, ProfileField.password, ProfileField.image],
        [ProfileField.login, ProfileField.stats, ProfileField.delete]
    ]
    init(dependencies: ProfileDependency) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        print(dataProfile?.name)
    }
  
    private func saveUser(player: String, account: String, platform: String) {
        
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
}


//MARK: - Subscriptions


//MARK: - Publishers




