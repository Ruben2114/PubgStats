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
            return "itemCellHelpDataQuestionReload".localize()
        case .deleteFav:
            return "itemCellHelpDataQuestionDeleteFav".localize()
        }
    }
    func response() -> String{
        switch self{
        case .reload:
            return "itemCellHelpDataResponseReload".localize()
        case .deleteFav:
            return "itemCellHelpDataResponseDeleteFav".localize()
        }
    }
}
