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
    private let loginDataUseCase: LoginDataUseCase
    
    init(state: PassthroughSubject<StateController, Never>, loginDataUseCase: LoginDataUseCase) {
        self.state = state
        self.loginDataUseCase = loginDataUseCase
    }
    
   
    func checkName(name: String, password: String) -> Bool {
            let check = loginDataUseCase.check(name: name, password: password)
            return check
    }
}
