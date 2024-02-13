//
//  AttributesHomeViewRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 3/2/24.
//

import Foundation


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
enum AttributesType {
    case weapons
    case modeGames
    
    func getTitle() -> String {
        switch self {
        case .weapons:
            return "Weapons"
        case .modeGames:
            return "gamesModesDataViewControllerTitle".localize()
        }
    }
    
    //TODO: poner bien las fotos
    func getImage() -> String {
        switch self {
        case .weapons:
            return "gamesModesDetailsPubg"
        case .modeGames:
            return "gamesModesDetailsPubg"
        }
    }
    
    func getRectangleHeaderLabel() -> String {
        switch self {
        case .weapons:
            return "Nivel"
        case .modeGames:
            return "Victorias"
        }
    }
    
    func getLeftHeaderLabel() -> String {
        switch self {
        case .weapons:
            return "Tier"
        case .modeGames:
            return "Partidas"
        }
    }
    
    func getRightHeaderLabel() -> String {
        switch self {
        case .weapons:
            return "XP"
        case .modeGames:
            return "Victorias"
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
            return "solo"
        case .soloFpp:
            return "solo Fpp"
        case .duo:
            return "duo"
        case .duoFpp:
            return "duo Fpp"
        case .squad:
            return "squad"
        case .squadFpp:
            return "squad Fpp"
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
