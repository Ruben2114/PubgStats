//
//  ItemCellProfile.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 18/4/23.
//

enum ProfileField{
    case name
    case email
    case password
    case image
    case login
    case stats
    case delete
    func title() -> String{
        switch self{
        case .name:
            return "profileFieldName".localize()
        case .email:
            return "profileFieldEmail".localize()
        case .password:
            return "profileFieldPassword".localize()
        case .image:
            return "profileFieldImage".localize()
        case .login:
            return "profileFieldLogin".localize()
        case .stats:
            return "profileFieldStats".localize()
        case .delete:
            return "profileFieldDelete".localize()
        }
    }
    func icon() -> String{
        switch self{
        case .name:
            return "person.circle.fill"
        case .email:
            return "envelope.circle.fill"
        case .password:
            return "lock.circle.fill"
        case .image:
            return "photo.circle.fill"
        case .login:
            return "person.crop.circle.fill.badge.plus"
        case .stats:
            return "folder.circle.fill"
        case .delete:
            return "trash.circle.fill"
        }
    }
}

