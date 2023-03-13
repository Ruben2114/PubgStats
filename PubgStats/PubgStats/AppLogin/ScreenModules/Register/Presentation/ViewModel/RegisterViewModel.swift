//
//  RegisterViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Foundation
import Combine

class RegisterViewModel {
    enum Output {
        case fetchError (error: Error)
        case fetchSave (model : Profile)
    }
    var state: PassthroughSubject<StateController, Never>
    private let profileDataUseCase: ProfileDataUseCase
    
    init(state: PassthroughSubject<StateController, Never>, profileDataUseCase: ProfileDataUseCase) {
        self.state = state
        self.profileDataUseCase = profileDataUseCase
    }
    
    func saveUser(_ user: ProfileModel) {
        state.send(.loading)
        Task {
            let result = await profileDataUseCase.execute(profile: user)
            state.send(.success)
            print("guardado")
        }
    }
}



