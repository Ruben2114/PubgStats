//
//  ProfileViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine
import CoreData

final class ProfileViewModel {
    private let apiService: ApiClientService
    var state = PassthroughSubject<OutputPlayer, Never>()
    var stateSave = PassthroughSubject<StateController, Never>()
    weak private var coordinator: ProfileCoordinator?
    private let profileDataUseCase: ProfileDataUseCase
    private let dependencies: ProfileDependency
    
    init(dependencies: ProfileDependency,apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.profileDataUseCase = dependencies.resolve()
    }
    
    func dataGeneral(name: String){
        guard let url = URL(string: ApisUrl.generalData(name: name).urlString) else { return }
        apiService.dataPlayer(url: url) { [weak self] (result: Result<PubgPlayer, Error>) in
                switch result {
                case .success(let generalData):
                    self?.state.send(.success(model: generalData))
                case .failure(let error):
                    self?.state.send(.fail(error: "\(error)"))
                }
        }
    }
    //TODO: GUARDAR ID EN CORE DATA
    private let context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
    func saveUser(player: String, account: String) {
        stateSave.send(.loading)
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let result = try context.fetch(fetchRequest)
            let namePlayer = result.map {$0.name}.description
            if sessionUser.name == namePlayer {
                let user = result.first
                user?.player = player
                user?.account = account
                try context.save()
                print("\(user?.account) y \(user?.name)")
                sessionUser.player = player
                sessionUser.account = account
                stateSave.send(.success)
            }
            
        } catch {
            stateSave.send(.fail(error: "Error al guardar los datos en core data"))
        }
        //profileDataUseCase.execute(name: name, password: password)
        stateSave.send(.success)
    }
    func logOut() {
        coordinator?.performTransition(.goLogOut)
    }
    func didTapPersonalDataButton() {
        coordinator?.performTransition(.goPersonalData)
    }
    func didTapSettingButton() {
        coordinator?.performTransition(.goSetting)
    }
    func didTapLinkPubgAccountButton() {
        coordinator?.performTransition(.goLinkPubg)
    }
    func didTapStatsgAccountButton() {
        coordinator?.performTransition(.goProfilePubg)
    }
}



