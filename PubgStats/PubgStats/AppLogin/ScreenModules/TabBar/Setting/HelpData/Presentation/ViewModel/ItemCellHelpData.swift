//
//  ItemCellHelpData.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 20/4/23.
//

enum ItemCellHelpData{
    case reload
    case deleteFav
    func question() -> String{
        switch self{
        case .reload:
            return "¿Cuando se recargan los datos?"
        case .deleteFav:
            return "¿Cómo borro a los usuarios favoritos de mi lista?"
        }
    }
    func response() -> String{
        switch self{
        case .reload:
            return "La recarga de los datos esta limitada por los servidores, si usted decide recargar podrá realizar dicha recarga 1 vez cada 2 horas. Sino automaticamente los datos se recargaran cada 12 horas desde su última búsqueda"
        case .deleteFav:
            return "Desliza el perfil de tu lista hacia la izquierda"
        }
    }
}
