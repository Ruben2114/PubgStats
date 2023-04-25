//
//  ItemCellSettings.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 19/4/23.
//

enum SettingsField{
    case help
    case email
    case legal
    case delete
    func title() -> String{
        switch self{
        case .help:
            return "settingsFieldHelp".localize()
        case .email:
            return "settingsFieldEmail".localize()
        case .legal:
            return "settingsFieldLegal".localize()
        case .delete:
            return "settingsFieldDelete".localize()
        }
    }
    func icon() -> String{
        switch self{
        case .help:
            return "questionmark.circle.fill"
        case .email:
            return "envelope.circle.fill"
        case .legal:
            return "info.circle.fill"
        case .delete:
            return "trash.circle.fill"
        }
    }
}

