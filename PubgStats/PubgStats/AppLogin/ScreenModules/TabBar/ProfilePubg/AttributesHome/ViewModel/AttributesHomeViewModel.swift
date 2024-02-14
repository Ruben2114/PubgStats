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
    @BindingOptional private var attributesHomeList: ProfileAttributesRepresentable?
    
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
   
    func goToAttributesDetails(_ select: AttributesHome){
        switch select.type {
        case .weapons:
            guard let summary = attributesHomeList?.infoWeapon?.weaponSummaries
                .filter({ $0.name == select.title })
                .first else { return }
            let attributesDetails = DefaultProfileAttributesDetails(infoWeaponDetails: summary, type: .weapons)
            coordinator.goToAttributesDetails(attributesDetails)
        case .modeGames:
            guard let summary = attributesHomeList?.infoGamesModes?.modes
                .filter({ $0.mode == select.title })
                .first else { return }
            let attributesDetails = DefaultProfileAttributesDetails(infoGamesModesDetails: summary, type: .modeGames)
            coordinator.goToAttributesDetails(attributesDetails)
        case .survival:
            break
        }
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
        let type: AttributesType = attributesHomeList?.infoGamesModes != nil ? .modeGames : .weapons
        switch type {
        case .weapons:
            return attributesHomeList?.infoWeapon?.weaponSummaries.map{getAttributesWeapons(statistics: $0)} ?? []
        case .modeGames:
            return attributesHomeList?.infoGamesModes?.modes.map{getAttributesModeGames(statistics: $0)} ?? []
        case .survival:
            return []
        }
    }
    
    func getAttributesWeapons(statistics: WeaponSummaryRepresentable) -> AttributesHome {
        return DefaultAttributesHome(title: statistics.name,
                                     rightAmount: statistics.xpTotal,
                                     leftAmount: statistics.tierCurrent,
                                     percentage: CGFloat(statistics.levelCurrent),
                                     image: statistics.name,
                                     type: .weapons)
    }
    
    func getAttributesModeGames(statistics: StatisticsGameModesRepresentable) -> AttributesHome {
        return DefaultAttributesHome(title: statistics.mode,
                                     rightAmount: statistics.wins,
                                     leftAmount: statistics.roundsPlayed,
                                     percentage: getPercentage(statistic: Double(statistics.wins),
                                                               total: Double(statistics.roundsPlayed)),
                                     image: statistics.mode,
                                     type: .modeGames)
    }
    
    func getPercentage(statistic: Double?, total: Double?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? ((statistic ?? 0) / (total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
}
