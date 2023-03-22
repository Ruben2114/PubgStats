//
//  ProfileViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine
import UIKit //esto deberia de quitarlo y dejarlo en otra parte

final class ProfileViewModel {
    private let apiService: ApiClientService
    var state = PassthroughSubject<OutputPlayer, Never>()
    var stateSave = PassthroughSubject<StateController, Never>()
    
    init(apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
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
    func saveUser(player: String, account: String) {
        stateSave.send(.loading)
        //profileDataUseCase.execute(name: name, password: password)
        stateSave.send(.success)
    }
    
    func chooseButton(buttonLink: UIButton, buttonStat: UIButton ) {
        if buttonLink.superview == nil {
            buttonLink.isHidden = false
            buttonStat.isHidden = true
        } else {
            buttonLink.isHidden = true
            buttonStat.isHidden = false
        }
    }
}



