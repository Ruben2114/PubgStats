//
//  AttributesHomeViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import Combine
import Foundation

final class AttributesHomeViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: AttributesHomeDependencies
    private let stateSubject = PassthroughSubject<[AttributesHome]?, Never>()
    var state: AnyPublisher<[AttributesHome]?, Never>
    @BindingOptional private var attributesHomeList: PlayerDetailsRepresentable?
    @BindingOptional private var type: AttributesType?
    
    init(dependencies: AttributesHomeDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        stateSubject.send(getAttributes())
    }
   
    func goToAttributesDetails(type: AttributesType){
        let attributesDetails: AttributesViewRepresentable?
        switch type {
        case .weapons:
            attributesDetails = nil
        case .modeGames:
            attributesDetails = nil
        case .survival:
            attributesDetails = nil
        }
        coordinator.goToAttributesDetails(attributesDetails)

    }
    
    func backButton() {
        coordinator.goBack()
    }
}

private extension AttributesHomeViewModel {
    var coordinator: AttributesHomeCoordinator {
        return dependencies.resolve()
    }
    
    func getAttributes() -> [AttributesHome] {
        guard let type = type else { return [] }
        switch type {
        case .weapons:
            return attributesHomeList?.infoWeapon.weaponSummaries.map{getAttributesDetailsWeapons(statistics: $0)} ?? []
        case .modeGames:
            return attributesHomeList?.infoGamesModes.modes.map{getAttributesDetailsModeGames(statistics: $0)} ?? []
        case .survival:
            return []
        }
    }
    
    func getAttributesDetailsWeapons(statistics: WeaponSummaryRepresentable) -> AttributesHome {
        return DefaultAttributesHome(title: statistics.name,
                                     rightAmount: statistics.xpTotal,
                                     leftAmount: statistics.tierCurrent,
                                     percentage: CGFloat(statistics.levelCurrent),
                                     image: statistics.name,
                                     type: .weapons)
    }
    
    func getAttributesDetailsModeGames(statistics: StatisticsGameModesRepresentable) -> AttributesHome {
       
        return DefaultAttributesHome(title: statistics.mode,
                                     rightAmount: statistics.wins,
                                     leftAmount: statistics.roundsPlayed,
                                     percentage: getPercentage(statistic: statistics.wins,
                                                               total: statistics.roundsPlayed),
                                     image: setImage(statistics.mode),
                                     type: .modeGames)
    }
    
    func setImage(_ mode: String) -> String {
        switch mode {
        case "solo", "soloFpp": return "soloGamesModes"
        case "duo", "duoFpp": return "duoGamesModes"
        case "squad", "squadFpp": return "squadGamesModes"
        default: return ""
        }
    }
    
    func getPercentage(statistic: Int?, total: Int?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? (Double(statistic ?? 0) / Double(total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
}

