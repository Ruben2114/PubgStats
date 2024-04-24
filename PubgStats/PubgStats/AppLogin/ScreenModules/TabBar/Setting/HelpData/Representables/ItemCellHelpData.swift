//
//  ItemCellHelpData.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 20/4/23.
//

enum ItemCellHelpData: CaseIterable {
    case reload
    case deleteFav
    //TODO: quitar la del reload y meter una de matches y del tema de buscar favoritos el sentitiveCase del naming
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
