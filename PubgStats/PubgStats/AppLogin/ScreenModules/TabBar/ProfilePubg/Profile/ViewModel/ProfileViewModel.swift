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
    case showChartView([PieChartViewDataRepresentable]?)
    case showErrorPlayerDetails
    case showGraphView(GraphInfoModesRepresentable?)
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
    
    func getChartData(infoGamesModes: GamesModesDataProfileRepresentable) {
        //TODO: crearlo a través de los datos de gamesmodes
        let chartData = [DefaultPieChartViewData(centerIconKey: "star", centerTitleText: "2552", centerSubtitleText: "Kills Total", categories: [
            DefaultCategory(percentage: 60, color: .red, secundaryColor: .systemRed, currentCenterTitleText: "1111", currentSubTitleText: "TItle1", icon: "star"),
            DefaultCategory(percentage: 30, color: .blue, secundaryColor: .systemBlue, currentCenterTitleText: "2222", currentSubTitleText: "TItle2", icon: "star"),
            DefaultCategory(percentage: 10, color: .yellow, secundaryColor: .systemYellow, currentCenterTitleText: "3333", currentSubTitleText: "Muerte por disparo en la cabeza", icon: "star")
        ], tooltipLabelTextKey: "Gráfica de las muertes totales"),
                         DefaultPieChartViewData(centerIconKey: "star", centerTitleText: "10000", centerSubtitleText: "Muerte por disparo en la cabeza", categories: [
                            DefaultCategory(percentage: 10, color: .gray, secundaryColor: .systemGray, currentCenterTitleText: "1000", currentSubTitleText: "Modo Solo", icon: "star"),
                            DefaultCategory(percentage: 30, color: .blue, secundaryColor: .systemBlue, currentCenterTitleText: "3000", currentSubTitleText: "Modo Duo", icon: "star"),
                            DefaultCategory(percentage: 20, color: .red, secundaryColor: .systemRed, currentCenterTitleText: "2000", currentSubTitleText: "Modo Squad", icon: "star"),
                            DefaultCategory(percentage: 10, color: .green, secundaryColor: .systemGreen, currentCenterTitleText: "1000", currentSubTitleText: "Modo Solo FPP", icon: "star"),
                            DefaultCategory(percentage: 20, color: .brown, secundaryColor: .systemBrown, currentCenterTitleText: "2000", currentSubTitleText: "Modo Duo FPP", icon: "star"),
                            DefaultCategory(percentage: 10, color: .yellow, secundaryColor: .systemYellow, currentCenterTitleText: "1000", currentSubTitleText: "Modo Squad FPP", icon: "star")
                         ], tooltipLabelTextKey: "Gráfica de las partidas por modos de juego")
        ]
        stateSubject.send(.showChartView(chartData))
    }
    
    func getGraphData(infoGamesModes: GamesModesDataProfileRepresentable) {
        let graphData = DefaultGraphInfoModes(firstGraph: getGraphAmounts(infoGamesModes.solo, infoGamesModes.soloFpp),
                                              secondGraph: getGraphAmounts(infoGamesModes.duo, infoGamesModes.duoFpp),
                                              thirdGraph: getGraphAmounts(infoGamesModes.squad, infoGamesModes.squadFpp))
        stateSubject.send(.showGraphView(graphData))
    }
    
    func getGraphAmounts(_ round: StatisticsGameModesRepresentable, _ roundFpp: StatisticsGameModesRepresentable) -> DoubleChartBarAdapterRepresentable {
        DefaultDoubleChartBarAdapter(firstBarValue: Double(round.roundsPlayed) ?? 0,
                                     secondBarValue: Double(roundFpp.roundsPlayed) ?? 0)
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
            self?.getChartData(infoGamesModes: data.infoGamesModes)
            self?.getGraphData(infoGamesModes: data.infoGamesModes)
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
