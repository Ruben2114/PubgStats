//
//  AttributesHomeViewRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 3/2/24.
//

import Foundation

public protocol ProfileAttributesDetailsRepresentable {
    var infoGamesModesDetails: StatisticsGameModesRepresentable? { get }
    var infoWeaponDetails: AttributesWeaponDetailsRepresentable? { get }
    var infoSurvivalDetails: SurvivalDataProfileRepresentable? { get }
    var type: AttributesType { get }
}

public protocol AttributesWeaponDetailsRepresentable {
    var weaponDetails: WeaponSummaryRepresentable { get }
    var killsTotal: Double { get }
    var damagePlayerTotal: Double { get }
    var headShotsTotal: Double { get }
    var groggiesTotal: Double { get }
}

struct DefaultProfileAttributesDetails: ProfileAttributesDetailsRepresentable {
    var infoGamesModesDetails: StatisticsGameModesRepresentable?
    var infoWeaponDetails: AttributesWeaponDetailsRepresentable?
    var infoSurvivalDetails: SurvivalDataProfileRepresentable?
    var type: AttributesType
    
    init(infoGamesModesDetails: StatisticsGameModesRepresentable? = nil, infoWeaponDetails: AttributesWeaponDetailsRepresentable? = nil, infoSurvivalDetails: SurvivalDataProfileRepresentable? = nil, type: AttributesType) {
        self.infoGamesModesDetails = infoGamesModesDetails
        self.infoWeaponDetails = infoWeaponDetails
        self.infoSurvivalDetails = infoSurvivalDetails
        self.type = type
    }
}

struct DefaultAttributesWeaponDetails: AttributesWeaponDetailsRepresentable {
    var weaponDetails: WeaponSummaryRepresentable
    var killsTotal: Double
    var damagePlayerTotal: Double
    var headShotsTotal: Double
    var groggiesTotal: Double
    
    init(weaponDetails: WeaponSummaryRepresentable, killsTotal: Double, damagePlayerTotal: Double, headShotsTotal: Double, groggiesTotal: Double) {
        self.weaponDetails = weaponDetails
        self.killsTotal = killsTotal
        self.damagePlayerTotal = damagePlayerTotal
        self.headShotsTotal = headShotsTotal
        self.groggiesTotal = groggiesTotal
    }
}

protocol AttributesViewRepresentable {
    var title: String { get }
    var image: String { get }
    var attributesHeaderDetails: [AttributesHeaderDetails] { get }
    var attributesDetails: [[AttributesDetails]] { get }
    var type: AttributesType { get }
}

protocol AttributesHeaderDetails {
    var title: String { get }
    var percentage: CGFloat { get }
}

protocol AttributesDetails {
    var titleSection: String? { get }
    var title: String { get }
    var amount: String { get }
}

protocol AttributesHome {
    var title: String { get }
    var rightAmount: Int? { get }
    var leftAmount: Int? { get }
    var percentage: CGFloat { get }
    var image: String { get }
    var type: AttributesType { get }
}

struct DefaultAttributesViewRepresentable: AttributesViewRepresentable {
    var title: String
    var image: String
    var attributesHeaderDetails: [AttributesHeaderDetails]
    var attributesDetails: [[AttributesDetails]]
    var type: AttributesType
    
    init(title: String, image: String, attributesHeaderDetails: [AttributesHeaderDetails], attributesDetails: [[AttributesDetails]], type: AttributesType) {
        self.title = title
        self.image = image
        self.attributesHeaderDetails = attributesHeaderDetails
        self.attributesDetails = attributesDetails
        self.type = type
    }
}

struct DefaultAttributesDetails: AttributesDetails {
    var titleSection: String?
    var title: String
    var amount: String
    
    init(titleSection: String? = nil, title: String, amount: String) {
        self.titleSection = titleSection
        self.title = title
        self.amount = amount
    }
}

struct DefaultAttributesHome: AttributesHome {
    var title: String
    var rightAmount: Int?
    var leftAmount: Int?
    var percentage: CGFloat
    var image: String
    var type: AttributesType
    
    init(title: String, rightAmount: Int? = nil, leftAmount: Int? = nil, percentage: CGFloat, image: String, type: AttributesType) {
        self.title = title
        self.rightAmount = rightAmount
        self.leftAmount = leftAmount
        self.percentage = percentage
        self.image = image
        self.type = type
    }
}

struct DefaultAttributesHeaderDetails: AttributesHeaderDetails {
    var title: String
    var percentage: CGFloat
    
    init(title: String, percentage: CGFloat) {
        self.title = title
        self.percentage = percentage
    }
}

//TODO: poner localized
public enum AttributesType {
    case weapons
    case modeGames
    case survival
    
    func getTitle() -> String {
        switch self {
        case .weapons:
            return "weaponDataViewControllerTitle".localize()
        case .modeGames:
            return "gamesModesDataViewControllerTitle".localize()
        case .survival:
            return "survivalDataViewControllerTitle".localize()
        }
    }
    
    //TODO: poner bien las fotos
    func getImage() -> String {
        switch self {
        case .weapons:
            return "gamesModesDetailsPubg"
        case .modeGames:
            return "gamesModesDetailsPubg"
        case .survival:
            return "gamesModesDetailsPubg"
        }
    }
    
    func getRectangleHeaderLabel() -> String {
        switch self {
        case .weapons:
            return "level".localize()
        case .modeGames:
            return "wins".localize()
        case .survival:
            return "Top 10: "
        }
    }
    
    func getLeftHeaderLabel() -> String {
        switch self {
        case .weapons:
            return "tier".localize()
        case .modeGames:
            return "gamesPlayed".localize()
        case .survival:
            return "gamesPlayed".localize()
        }
    }
    
    func getRightHeaderLabel() -> String {
        switch self {
        case .weapons:
            return "XP"
        case .modeGames:
            return "wins".localize()
        case .survival:
            return "XP"
        }
    }
}

//TODO: poner localized
enum GamesModesTypes {
    case solo
    case soloFpp
    case duo
    case duoFpp
    case squad
    case squadFpp
    
    func setTitle() -> String {
        switch self {
        case .solo:
            return "solo".localize()
        case .soloFpp:
            return "soloFpp".localize()
        case .duo:
            return "duo".localize()
        case .duoFpp:
            return "duoFpp".localize()
        case .squad:
            return "squad".localize()
        case .squadFpp:
            return "squadFpp".localize()
        }
    }
    
    func setImage() -> String {
        switch self {
        case .solo, .soloFpp:
            return "soloGamesModes"
        case .duo, .duoFpp:
            return "duoGamesModes"
        case .squad, .squadFpp:
            return "squadGamesModes"
        }
    }
}
