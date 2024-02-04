//
//  AttributesHomeViewRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 3/2/24.
//

import Foundation

protocol AttributesViewRepresentable {
    var title: String { get }
    var attributesHeaderDetails: [AttributesHeaderDetails] { get }
    var attributesDetails: [[AttributesDetails]] { get }
    var attributesHome: AttributesHome { get }
    var isDetails: Bool { get set }
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
    var rightAmount: Int? { get }
    var leftAmount: Int? { get }
    var percentage: CGFloat { get }
    var image: String { get }
}

struct DefaultAttributesViewRepresentable: AttributesViewRepresentable {
    var title: String
    var attributesHeaderDetails: [AttributesHeaderDetails]
    var attributesDetails: [[AttributesDetails]]
    var attributesHome: AttributesHome
    var isDetails: Bool
    var type: AttributesType
    
    init(title: String, attributesHeaderDetails: [AttributesHeaderDetails], attributesDetails: [[AttributesDetails]], attributesHome: AttributesHome, isDetails: Bool, type: AttributesType) {
        self.title = title
        self.attributesHeaderDetails = attributesHeaderDetails
        self.attributesDetails = attributesDetails
        self.attributesHome = attributesHome
        self.isDetails = isDetails
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
    var rightAmount: Int?
    var leftAmount: Int?
    var percentage: CGFloat
    var image: String
    
    init(rightAmount: Int? = nil, leftAmount: Int? = nil, percentage: CGFloat, image: String) {
        self.rightAmount = rightAmount
        self.leftAmount = leftAmount
        self.percentage = percentage
        self.image = image
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

enum AttributesType {
    case weapons
    case modeGames
    case matches
    
    func getTitle() -> String {
        switch self {
        case .weapons:
            return "Weapons"
        case .modeGames:
            return "gamesModesDataViewControllerTitle".localize()
        case .matches:
            return "Matches"
        }
    }
    
    //TODO: poner bien las fotos
    func getImage() -> String {
        switch self {
        case .weapons:
            return "gamesModesDetailsPubg"
        case .modeGames:
            return "gamesModesDetailsPubg"
        case .matches:
            return "gamesModesDetailsPubg"
        }
    }
    
    func getRectangleHeaderLabel() -> String {
        switch self {
        case .weapons:
            return "Nivel"
        case .modeGames:
            return "Victorias"
        case .matches:
            return "Partidas"
        }
    }
    
    func getLeftHeaderLabel() -> String {
        switch self {
        case .weapons:
            return "Tier"
        case .modeGames:
            return "Partidas"
        case .matches:
            return "Partidas"
        }
    }
    
    func getRightHeaderLabel() -> String {
        switch self {
        case .weapons:
            return "XP"
        case .modeGames:
            return "Victorias"
        case .matches:
            return "Partidas"
        }
    }
}
