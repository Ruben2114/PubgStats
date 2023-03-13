//
//  HomeMenuViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation
import Combine



final class HomeMenuViewModel {
    
    
    var state: PassthroughSubject<StateController, Never>
    private let profileDataUseCase: ProfileDataUseCase
    private var profileModel = ProfileModel(name: "", password: "")
    
    init(state: PassthroughSubject<StateController, Never>, profileDataUseCase: ProfileDataUseCase) {
        self.state = state
        self.profileDataUseCase = profileDataUseCase
    }
    
    func viewDidLoad(){
        state.send(.loading)
        Task {
            let profileResult = await profileDataUseCase.execute(profile: profileModel)
            state.send(.success)
            print("voy por aqui")
        }
    }
}
