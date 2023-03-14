//
//  HomeMenuViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation

final class HomeMenuViewModel {
    
    private let loginDataUseCase: LoginDataUseCase
    
    init(loginDataUseCase: LoginDataUseCase) {
        self.loginDataUseCase = loginDataUseCase
    }
    
    func checkName(name: String, password: String) -> Bool {
            let check = loginDataUseCase.check(name: name, password: password)
            return check
    }
}
