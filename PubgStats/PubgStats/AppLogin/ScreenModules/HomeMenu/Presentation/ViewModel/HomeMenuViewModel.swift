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
    private var profileModel: Profile?
    
    init(state: PassthroughSubject<StateController, Never>, loginDataUseCase: LoginDataUseCase) {
        self.state = state
        self.loginDataUseCase = loginDataUseCase
    }
    
    func viewDidLoad(name: String, password: String){
        state.send(.loading)
        Task {
            do {
                let userResult = try await loginDataUseCase.execute()
                profileModel = userResult
                state.send(.success)
            }catch{
                state.send(.fail(error: error.localizedDescription))
            }
        }
    }
    private let context = CoreDataManager.shared.persistentContainer.viewContext
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
