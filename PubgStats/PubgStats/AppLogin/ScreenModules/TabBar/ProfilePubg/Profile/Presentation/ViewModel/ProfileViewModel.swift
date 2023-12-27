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
    case showChartView([PieChartViewData]?)
    case showErrorPlayerDetails
    case hideLoading
}

final class ProfileViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: ProfileDependency
    private let stateSubject = CurrentValueSubject<ProfileState, Never>(.idle)
    var state: AnyPublisher<ProfileState, Never>
    private let getPlayerDetailsSubject = PassthroughSubject<IdAccountDataProfileRepresentable, Never>()
    @BindingOptional private var dataProfile: IdAccountDataProfileRepresentable?
  
    init(dependencies: ProfileDependency) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        subscribePlayerDetailsPublisher()
        getPlayerDetailsSubject.send(dataProfile ?? DefaultIdAccountDataProfile(id: "", name: "", platform: ""))
    }
    
    func reload(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "reload")
        //TODO: hacer las llamadas sin ser cacheadas
    }
}

private extension ProfileViewModel {
    var coordinator: ProfileCoordinator {
        return dependencies.resolve()
    }
    
    var profileDataUseCase: ProfileDataUseCase {
        return dependencies.resolve()
    }
    
    func getChartData(infoGamesModes: GamesModesDataProfileRepresentable) -> [PieChartViewData]? {
        //TODO: crearlo a través de los datos de gamesmodes
        [PieChartViewData(centerIconKey: "star", centerTitleText: "2552", centerSubtitleText: "Kills Total", categories: [
                CategoryRepresentable(percentage: 60, color: .red, secundaryColor: .systemRed, currentCenterTitleText: "1111", currentSubTitleText: "TItle1", iconUrl: "star"),
                CategoryRepresentable(percentage: 30, color: .blue, secundaryColor: .systemBlue, currentCenterTitleText: "2222", currentSubTitleText: "TItle2", iconUrl: "star"),
                CategoryRepresentable(percentage: 10, color: .yellow, secundaryColor: .systemYellow, currentCenterTitleText: "3333", currentSubTitleText: "Muerte por disparo en la cabeza", iconUrl: "star")
            ], tooltipLabelTextKey: "Gráfica de las muertes totales"),
            PieChartViewData(centerIconKey: "star", centerTitleText: "10000", centerSubtitleText: "Muerte por disparo en la cabeza", categories: [
                CategoryRepresentable(percentage: 10, color: .gray, secundaryColor: .systemGray, currentCenterTitleText: "1000", currentSubTitleText: "Modo Solo", iconUrl: "star"),
                CategoryRepresentable(percentage: 30, color: .blue, secundaryColor: .systemBlue, currentCenterTitleText: "3000", currentSubTitleText: "Modo Duo", iconUrl: "star"),
                CategoryRepresentable(percentage: 20, color: .red, secundaryColor: .systemRed, currentCenterTitleText: "2000", currentSubTitleText: "Modo Squad", iconUrl: "star"),
                CategoryRepresentable(percentage: 10, color: .green, secundaryColor: .systemGreen, currentCenterTitleText: "1000", currentSubTitleText: "Modo Solo FPP", iconUrl: "star"),
                CategoryRepresentable(percentage: 20, color: .brown, secundaryColor: .systemBrown, currentCenterTitleText: "2000", currentSubTitleText: "Modo Duo FPP", iconUrl: "star"),
                CategoryRepresentable(percentage: 10, color: .yellow, secundaryColor: .systemYellow, currentCenterTitleText: "1000", currentSubTitleText: "Modo Squad FPP", iconUrl: "star")
            ], tooltipLabelTextKey: "Gráfica de las partidas por modos de juego")
        ]
    }
}


//MARK: - Subscriptions
private extension ProfileViewModel {
    func subscribePlayerDetailsPublisher() {
        playerDetailsPublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                self?.stateSubject.send(.showErrorPlayerDetails)
                self?.stateSubject.send(.hideLoading)
                self?.subscribePlayerDetailsPublisher()
            default: break
            }
        } receiveValue: { [weak self] data in
            //TODO: aqui ya tengo toda la info ahora seria ir enviando a las vistas la información
            self?.stateSubject.send(.showChartView(self?.getChartData(infoGamesModes: data.infoGamesModes)))
            self?.stateSubject.send(.hideLoading)
        }.store(in: &anySubscription)
    }
}

//MARK: - Publishers

private extension ProfileViewModel {
    func playerDetailsPublisher() -> AnyPublisher<PlayerDetailsRepresentable, Error> {
        return getPlayerDetailsSubject.flatMap { [unowned self] data in
            self.profileDataUseCase.fetchPlayerDetails(data)
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
