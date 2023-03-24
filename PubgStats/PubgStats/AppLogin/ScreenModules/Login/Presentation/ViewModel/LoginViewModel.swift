//
//  LoginViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation
import Combine

final class LoginViewModel {
    var state = PassthroughSubject<StateController, Never>()
    weak private var coordinator: LoginCoordinator?
    private let loginDataUseCase: LoginDataUseCase
    private let dependencies: LoginDependency
    
    init(dependencies: LoginDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.loginDataUseCase = dependencies.resolve()
    }
    
    func checkName(sessionUser: ProfileEntity, name: String, password: String) {
        state.send(.loading)
        Task { [weak self] in
            let check = loginDataUseCase.check(sessionUser: sessionUser ,name: name, password: password)
            switch check {
            case true:
                self?.state.send(.success)
                self?.loginSucess(name: name, password: password)
            case false:
                self?.state.send(.fail(error: "Incorrect username or password."))
            }
        }
    }
    func loginSucess(name: String, password: String) {
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        sessionUser.name = name
        sessionUser.password = password
        coordinator?.performTransition(.goProfile)
    }
    func didTapForgotButton() {
        coordinator?.performTransition(.goForgot)
    }
    func didTapRegisterButton() {
        coordinator?.performTransition(.goRegister)
    }
    /*
    private let context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
    func viewDidLoad(){
        //TODO: leer datos de usuario
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let result = try context.fetch(fetchRequest)
            let namePlayer = result.map {$0}
            if sessionUser.name == namePlayer.first?.name {
                sessionUser.player = namePlayer.first?.player
                sessionUser.account = namePlayer.first?.account
            }
        } catch {
            print("Error en core data")
        }
        
    }
     */
}
