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
        coordinator.goToAttributes(attributes: representable, type: .modeGames)
    }
    
    func goToWeapon() {
        coordinator.goToAttributes(attributes: representable, type: .weapons)
    }
    
    func goToSurvival() {
        coordinator.goToAttributes(attributes: representable, type: .survival)
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

//private extension ProfileViewModel {
//    
//    func getAttributesDetailsModeGames(statistics: StatisticsGameModesRepresentable?, type: GamesModeType) -> AttributesViewRepresentable {
//        return DefaultAttributesViewRepresentable(title: type.getTitle(),
//                                                  attributesHeaderDetails: getAttributesHeaderDetails(statistics: statistics),
//                                                  attributesDetails: getAttributesDetails(statistics: statistics),
//                                                  attributesHome: DefaultAttributesHome(rightAmount: statistics?.wins,
//                                                                                        leftAmount: statistics?.roundsPlayed,
//                                                                                        percentage: getPercentage(statistic: statistics?.wins,
//                                                                                                                  total: statistics?.roundsPlayed),
//                                                                                        image: type.setImage()),
//                                                  isDetails: false,
//                                                  type: .modeGames)
//    }
//    
//    func getAttributesDetails(statistics: StatisticsGameModesRepresentable?) -> [[AttributesDetails]] {
//        guard let statistics = statistics else { return []}
//        var attributes: [[AttributesDetails]] = []
//        
//        
//        
//        let attributesSectionOne: [AttributesDetails] = [getAttributesDetails("max Kill Streaks", "\(statistics.maxKillStreaks)", "Kills"),
//                                                         getAttributesDetails("round Most Kills", "\(statistics.roundMostKills)"),
//                                                         getAttributesDetails("killed a teammate", "\(statistics.teamKills)"),
//                                                         getAttributesDetails("road Kills", "\(statistics.roadKills)"),
//                                                         getAttributesDetails("kills", "\(statistics.kills)"),
//                                                         getAttributesDetails("longest Kill", "\(String(format: "%.0f", statistics.longestKill)) m")]
//        
//        let attributesSectionTwo: [AttributesDetails] = [getAttributesDetails("longest Time Survived", getTime(statistics.mostSurvivalTime, true), "General"),
//                                                         getAttributesDetails("losses", "\(statistics.losses)"),
//                                                         getAttributesDetails("damage", String(format: "%.0f", statistics.damageDealt)),
//                                                         getAttributesDetails("Asistencias", "\(statistics.assists)"),
//                                                         getAttributesDetails("knocked", "\(statistics.dBNOS)"),
//                                                         getAttributesDetails("suicides", "\(statistics.suicides)"),
//                                                         getAttributesDetails("time Survived", getTime(statistics.timeSurvived)),
//                                                         getAttributesDetails("vehicle Destroys", "\(statistics.vehicleDestroys)"),
//                                                         getAttributesDetails("revives", "\(statistics.revives)")]
//        
//        let attributesSectionThree: [AttributesDetails] = [getAttributesDetails("Andando", getDistance(statistics.walkDistance), "Distance"),
//                                                           getAttributesDetails("Conduciendo", getDistance(statistics.rideDistance)),
//                                                           getAttributesDetails("Nadando", getDistance(statistics.swimDistance))]
//        
//        let attributesSectionFour: [AttributesDetails] = [getAttributesDetails("boost", "\(statistics.boosts)", "Items"),
//                                                          getAttributesDetails("healing", "\(statistics.heals)"),
//                                                          getAttributesDetails("weapons", "\(statistics.weaponsAcquired)")]
//        [attributesSectionOne, attributesSectionTwo, attributesSectionThree, attributesSectionFour].forEach { data in
//            attributes.append(data)
//        }
//        return attributes
//    }
//    
//    func getAttributesDetails(_ title: String, _ amount: String, _ titleSection: String? = nil) -> AttributesDetails {
//        return DefaultAttributesDetails(titleSection: titleSection,
//                                        title: title,
//                                        amount: amount)
//    }
//    
//    func getAttributesHeaderDetails(statistics: StatisticsGameModesRepresentable?) -> [AttributesHeaderDetails] {
//        let killsDay = getPercentage(statistic: statistics?.kills, total: statistics?.roundsPlayed, optional: true)
//        let winsDay = getPercentage(statistic: statistics?.wins, total: statistics?.days, optional: true)
//        
//        return [DefaultAttributesHeaderDetails(title: "Tops 10: \(statistics?.top10S ?? 0)",
//                                               percentage: getPercentage(statistic: statistics?.top10S, total: statistics?.roundsPlayed)),
//                DefaultAttributesHeaderDetails(title: "Headshot Kills: \(statistics?.headshotKills ?? 0)",
//                                               percentage: getPercentage(statistic: statistics?.headshotKills, total: statistics?.kills)),
//                DefaultAttributesHeaderDetails(title: "kills per game: \(String(format: "%.2f", killsDay))",
//                                               percentage: killsDay),
//                DefaultAttributesHeaderDetails(title: "Wins per day: \(String(format: "%.2f", winsDay))",
//                                               percentage: winsDay)]
//    }
//}
//
////MARK: - Attributes Mode Games
//private extension ProfileViewModel {
//    func getPercentage(statistic: Int?, total: Int?, optional: Bool = false) -> CGFloat {
//        let percentage = statistic != 0 && total != 0 ? (Double(statistic ?? 0) / Double(total ?? 0)) : 0
//        let optionalPercentage = optional ? percentage : percentage * 100
//        return CGFloat(optionalPercentage)
//    }
//    
//    func getDistance(_ distance: Double) -> String {
//        let distanceKM = distance / 1000
//        return "\(String(format: "%.2f", distanceKM)) km"
//    }
//    
//    func getTime(_ time: Double, _ withMinutes: Bool = false) -> String {
//        let days = Int(round(time / 86400))
//        let hours = Int(round((time.truncatingRemainder(dividingBy: 86400)) / 3600))
//        let minutes = Int(round((time.truncatingRemainder(dividingBy: 3600)) / 60))
//        return withMinutes ? "\(hours) h \(minutes) m" : "\(days) d \(hours) h"
//    }
//}
