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
        coordinator.goToAttributes(attributes: getAttributesModeGames(), type: .modeGames)
    }
    
    func goToWeapon() {
        //TODO: coodinator
    }
    
    func goToSurvival() {
        //TODO: coodinator
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
        let roadKillsTotal = infoGamesModes.solo.roadKills + infoGamesModes.soloFpp.roadKills + infoGamesModes.duo.roadKills + infoGamesModes.duoFpp.roadKills + infoGamesModes.squad.roadKills + infoGamesModes.soloFpp.roadKills
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
    
    func getGraphData(infoGamesModes: GamesModesDataProfileRepresentable) {
        let graphData = DefaultGraphInfoModes(firstGraph: getGraphAmounts(infoGamesModes.solo, infoGamesModes.soloFpp),
                                              secondGraph: getGraphAmounts(infoGamesModes.duo, infoGamesModes.duoFpp),
                                              thirdGraph: getGraphAmounts(infoGamesModes.squad, infoGamesModes.squadFpp))
        stateSubject.send(.showGraphView(graphData))
    }
    
    func getGraphAmounts(_ round: StatisticsGameModesRepresentable, _ roundFpp: StatisticsGameModesRepresentable) -> DoubleChartBarAdapterRepresentable {
        DefaultDoubleChartBarAdapter(firstBarValue: round.roundsPlayed,
                                     secondBarValue: roundFpp.roundsPlayed)
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

//MARK: - Attributes Mode Games
private extension ProfileViewModel {
    func getAttributesModeGames() -> [AttributesViewRepresentable] {
        var attributes: [AttributesViewRepresentable] = []
        let attributesSolo = getAttributesDetailsModeGames(statistics: representable?.infoGamesModes.solo, type: .solo)
        let attributesSoloFpp = getAttributesDetailsModeGames(statistics: representable?.infoGamesModes.soloFpp, type: .soloFpp)
        let attributesDuo = getAttributesDetailsModeGames(statistics: representable?.infoGamesModes.duo, type: .duo)
        let attributesDuoFpp = getAttributesDetailsModeGames(statistics: representable?.infoGamesModes.duoFpp, type: .duoFpp)
        let attributesSquad = getAttributesDetailsModeGames(statistics: representable?.infoGamesModes.squad, type: .squad)
        let attributesSquadFpp = getAttributesDetailsModeGames(statistics: representable?.infoGamesModes.squadFpp, type: .squadFpp)
        
        [attributesSolo, attributesSoloFpp, attributesDuo, attributesDuoFpp, attributesSquad, attributesSquadFpp].forEach { data in
            attributes.append(data)
        }
        return attributes
    }
    
    func getAttributesDetailsModeGames(statistics: StatisticsGameModesRepresentable?, type: GamesModeType) -> AttributesViewRepresentable {
        return DefaultAttributesViewRepresentable(title: type.getTitle(),
                                                  attributesHeaderDetails: getAttributesHeaderDetails(statistics: statistics),
                                                  attributesDetails: getAttributesDetails(statistics: statistics),
                                                  attributesHome: DefaultAttributesHome(rightAmount: statistics?.wins,
                                                                                                 leftAmount: statistics?.roundsPlayed,
                                                                                                 percentage: getPercentage(statistic: statistics?.wins,
                                                                                                                           total: statistics?.roundsPlayed),
                                                                                                 image: type.setImage()),
                                                  isDetails: false,
                                                  type: .modeGames)
    }
    
    func getAttributesDetails(statistics: StatisticsGameModesRepresentable?) -> [[AttributesDetails]] {
        guard let statistics = statistics else { return []}
        var attributes: [[AttributesDetails]] = []
        let attributesSectionOne: [AttributesDetails] = [DefaultAttributesDetails(titleSection: "Kills",
                                                                                  title: "max Kill Streaks",
                                                                                  amount: "\(statistics.maxKillStreaks)"),
                                                         DefaultAttributesDetails(title: "round Most Kills",
                                                                                  amount: "\(statistics.roundMostKills)"),
                                                         DefaultAttributesDetails(title: "player killed a teammate",
                                                                                  amount: "\(statistics.teamKills)"),
                                                         DefaultAttributesDetails(title: "road Kills",
                                                                                  amount: "\(statistics.roadKills)"),
                                                         DefaultAttributesDetails(title: "kills",
                                                                                  amount: "\(statistics.kills)"),
                                                         DefaultAttributesDetails(title: "longest Kill",
                                                                                  amount: "\(statistics.longestKill)")]
        
        let attributesSectionTwo: [AttributesDetails] = [DefaultAttributesDetails(titleSection: "General",
                                                                                  title: "longest Time Survived",
                                                                                  amount: "\(statistics.mostSurvivalTime)"),
                                                         DefaultAttributesDetails(title: "losses",
                                                                                  amount: "\(statistics.losses)"),
                                                         DefaultAttributesDetails(title: "damage dealt",
                                                                                  amount: "\(statistics.damageDealt)"),
                                                         DefaultAttributesDetails(title: "Asistencias",
                                                                                  amount: "\(statistics.assists)"),
                                                         DefaultAttributesDetails(title: "players knocked",
                                                                                  amount: "\(statistics.dBNOS)"),
                                                         DefaultAttributesDetails(title: "suicides",
                                                                                  amount: "\(statistics.suicides)"),
                                                         DefaultAttributesDetails(title: "time Survived",
                                                                                  amount: "\(statistics.timeSurvived)"),
                                                         DefaultAttributesDetails(title: "vehicle Destroys",
                                                                                  amount: "\(statistics.vehicleDestroys)"),
                                                         DefaultAttributesDetails(title: "revives",
                                                                                  amount: "\(statistics.revives)")]
        
        let attributesSectionThree: [AttributesDetails] = [DefaultAttributesDetails(titleSection: "Distance",
                                                                                    title: "Distancia andando",
                                                                                    amount: "\(statistics.walkDistance)"),
                                                           DefaultAttributesDetails(title: "Distancia conduciendo",
                                                                                    amount: "\(statistics.rideDistance)"),
                                                           DefaultAttributesDetails(title: "Distancia nadando",
                                                                                    amount: "\(statistics.swimDistance)")]
        let attributesSectionFour: [AttributesDetails] = [DefaultAttributesDetails(titleSection: "Items",
                                                                                   title: "boost items",
                                                                                   amount: "\(statistics.boosts)"),
                                                          DefaultAttributesDetails(title: "healing items",
                                                                                   amount: "\(statistics.heals)"),
                                                          DefaultAttributesDetails(title: "weaponsAcquired",
                                                                                   amount: "\(statistics.weaponsAcquired)")]
        [attributesSectionOne, attributesSectionTwo, attributesSectionThree, attributesSectionFour].forEach { data in
            attributes.append(data)
        }
        return attributes
    }
    
    func getAttributesHeaderDetails(statistics: StatisticsGameModesRepresentable?) -> [AttributesHeaderDetails] {
        let killsDay = getPercentage(statistic: statistics?.kills, total: statistics?.days, optional: true)
        let winsDay = getPercentage(statistic: statistics?.wins, total: statistics?.days, optional: true)
        return [DefaultAttributesHeaderDetails(title: "Tops 10: \(statistics?.top10S ?? 0) %",
                                      percentage: getPercentage(statistic: statistics?.top10S, total: statistics?.roundsPlayed)),
                DefaultAttributesHeaderDetails(title: "Headshot Kills: \(statistics?.headshotKills ?? 0) %",
                                      percentage: getPercentage(statistic: statistics?.headshotKills, total: statistics?.kills)),
                DefaultAttributesHeaderDetails(title: "kills per day: \(killsDay) %",
                                      percentage: killsDay),
                DefaultAttributesHeaderDetails(title: "Wins per day: \(winsDay) %",
                                      percentage: winsDay)]
    }
    
    func getPercentage(statistic: Int?, total: Int?, optional: Bool = false) -> CGFloat {
        if !optional {
            return statistic != 0 && total != 0 ? (CGFloat(statistic ?? 0) / CGFloat(total ?? 0) * 100).rounded() : 0
        } else {
            let percentage = statistic != 0 && total != 0 ? (CGFloat(statistic ?? 0) / CGFloat(total ?? 0)).rounded() : 0
            let percentageOptional = (percentage * CGFloat(statistic ?? 0) / 100 ).rounded()
            return percentageOptional
        }
    }
}

enum GamesModeType {
    case solo
    case soloFpp
    case duo
    case duoFpp
    case squad
    case squadFpp
    
    func getTitle() -> String {
        //TODO: poner localized
        switch self {
        case .solo:
            return "solo"
        case .soloFpp:
            return "soloFpp"
        case .duo:
            return "duo"
        case .duoFpp:
            return "duoFpp"
        case .squad:
            return "squad"
        case .squadFpp:
            return "squadFpp"
        }
    }
    
    func setImage() -> String {
        switch self {
        case .solo, .soloFpp: return "soloGamesModes"
        case .duo, .duoFpp: return "duoGamesModes"
        case .squad, .squadFpp: return "squadGamesModes"
        }
    }
}
