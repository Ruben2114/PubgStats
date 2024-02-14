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
    case showHeader(ProfileHeaderViewRepresentable)
}

final class ProfileViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: ProfileDependency
    private let stateSubject = CurrentValueSubject<ProfileState, Never>(.idle)
    var state: AnyPublisher<ProfileState, Never>
    private let getPlayerDetailsSubject = PassthroughSubject<IdAccountDataProfileRepresentable, Never>()
    @BindingOptional private var dataProfile: IdAccountDataProfileRepresentable?
    private var representable: PlayerDetailsRepresentable?
    
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
    
    func goToModes() {
        let attributes = DefaultProfileAttributes(infoGamesModes: representable?.infoGamesModes)
        coordinator.goToAttributes(attributes: attributes)
    }
    
    func goToWeapon() {
        let attributes = DefaultProfileAttributes(infoWeapon: representable?.infoWeapon)
        coordinator.goToAttributes(attributes: attributes)
    }
    
    func goToSurvival() {
        //TODO: directamente a details
    }
    
    func reload(){
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
        //TODO: refactor con el dato desde la llamada
        var roadKillsTotal: Int = 0
        let roadKills = infoGamesModes.modes.map({$0.roadKills})
        roadKills.forEach { kills in
            roadKillsTotal += kills
        }
        let restKills = infoGamesModes.killsTotal - roadKillsTotal - infoGamesModes.headshotKillsTotal
        let kills = getCategoriesData(stats: PlayerStats.kills,
                                      amount: String(infoGamesModes.killsTotal),
                                      subcategories: [getSubcategoriesData(stats: PlayerStats.headshotKills, percentage: getSubcategoriesPercentage(valueTotal: infoGamesModes.killsTotal, valueSubcategory: infoGamesModes.headshotKillsTotal), amount: infoGamesModes.headshotKillsTotal.description),
                                                      getSubcategoriesData(stats: PlayerStats.roadKills, percentage: getSubcategoriesPercentage(valueTotal: infoGamesModes.killsTotal, valueSubcategory: roadKillsTotal), amount: roadKillsTotal.description),
                                                      getSubcategoriesData(stats: PlayerStats.rest, percentage: getSubcategoriesPercentage(valueTotal: infoGamesModes.killsTotal, valueSubcategory: restKills), amount: restKills.description)])
   //TODO: pensar como meter el resto de forma mas practica o incluso en el componente si detecta que no llega al 100%

        let chartData = [kills]
        stateSubject.send(.showChartView(chartData))
    }
    
    func getCategoriesData(stats: PlayerStats, amount: String, subcategories: [CategoryRepresentable]) -> DefaultPieChartViewData {
        DefaultPieChartViewData(centerIconKey: stats.icon(),
                                centerTitleText: amount,
                                centerSubtitleText: stats.title(),
                                categories: subcategories,
                                tooltipLabelTextKey: stats.tooltipLabel() ?? "")
    }
    
    func getSubcategoriesData(stats: PlayerStats, percentage: Double, amount: String) -> CategoryRepresentable {
        DefaultCategory(percentage: percentage,
                        color: stats.color()?.0 ?? .gray,
                        secundaryColor: stats.color()?.1 ?? .systemGray,
                        currentCenterTitleText: amount,
                        currentSubTitleText: stats.title(),
                        icon: stats.icon())
    }
    
    func getSubcategoriesPercentage(valueTotal: Int, valueSubcategory: Int) -> Double {
        let amount: Decimal = Decimal(valueSubcategory * 100) / Decimal(valueTotal)
        return NSDecimalNumber(decimal: amount).doubleValue
    }
    
    func getGraphData() {
        let graphData = DefaultGraphInfoModes(firstGraph: getGraphAmounts(ModesValues.solo, ModesValues.soloFpp),
                                              secondGraph: getGraphAmounts(ModesValues.duo, ModesValues.duoFpp),
                                              thirdGraph: getGraphAmounts(ModesValues.squad, ModesValues.squadFpp))
        stateSubject.send(.showGraphView(graphData))
    }
    
    func getGraphAmounts(_ round: String ,_ roundFpp: String) -> DoubleChartBarAdapterRepresentable {
        DefaultDoubleChartBarAdapter(firstBarValue: representable?.infoGamesModes.modes.first(where: {$0.mode == round})?.roundsPlayed ?? 0,
                                     secondBarValue: representable?.infoGamesModes.modes.first(where: {$0.mode == roundFpp})?.roundsPlayed ?? 0)
    }
    
    func getProfileHeader(_ info: SurvivalDataProfileRepresentable) {
        let profileHeader = DefaultProfileHeaderView(dataPlayer: dataProfile ?? DefaultIdAccountDataProfile(id: "", name: "", platform: ""),
                                                     level: info.level,
                                                     xp: info.xp)
        stateSubject.send(.showHeader(profileHeader))
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
            self?.representable = data
            //TODO: aqui ya tengo toda la info ahora seria ir enviando a las vistas la información
            self?.getProfileHeader(data.infoSurvival)
            self?.getChartData(infoGamesModes: data.infoGamesModes)
            self?.getGraphData()
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
