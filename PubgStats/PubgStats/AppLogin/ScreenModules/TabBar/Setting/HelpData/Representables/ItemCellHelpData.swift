//
//  ItemCellHelpData.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 20/4/23.
//

enum ItemCellHelpData: CaseIterable {
    case matches
    case deleteFav
    case searchFav

    func question() -> String{
        switch self{
        case .matches:
            return "itemCellHelpDataQuestionMatches".localize()
        case .deleteFav:
            return "itemCellHelpDataQuestionDeleteFav".localize()
        case .searchFav:
            return "itemCellHelpDataQuestionSearchFav".localize()
        }
    }
    
    func response() -> String{
        switch self{
        case .matches:
            return "itemCellHelpDataResponseMatches".localize()
        case .deleteFav:
            return "itemCellHelpDataResponseDeleteFav".localize()
        case .searchFav:
            return "itemCellHelpDataResponseSearchFav".localize()
        }
    }
}
