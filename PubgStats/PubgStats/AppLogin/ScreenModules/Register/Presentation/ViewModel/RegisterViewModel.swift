//
//  RegisterViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Foundation
import Combine

class RegisterViewModel {
    
    var state: PassthroughSubject<StateController, Never>
    private let registerDataUseCase: RegisterDataUseCase
    
    init(state: PassthroughSubject<StateController, Never>, registerDataUseCase: RegisterDataUseCase) {
        self.state = state
        self.registerDataUseCase = registerDataUseCase
    }
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    func saveUser(name: String, password: String) {
        state.send(.loading)
        Task {
            let newUser = Profile(context: context)
            newUser.name = name
            newUser.password = password
            _ = registerDataUseCase.execute(profile: newUser)
            state.send(.success)
        }
    }
    func checkIfNameExists(name: String) -> Bool {
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            return result.count > 0
        } catch let error {
            print("Error checking if name exists: \(error)")
            return false
        }
    }
}

