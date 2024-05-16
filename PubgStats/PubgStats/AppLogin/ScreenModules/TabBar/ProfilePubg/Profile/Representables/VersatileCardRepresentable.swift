//
//  VersatilCardRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 15/1/24.
//

protocol VersatileCardRepresentable {
    var title: String { get }
    var subTitle: String? { get }
    var customImageView: String? { get }
}

struct DefaultVersatilCard: VersatileCardRepresentable {
    var title: String
    var subTitle: String?
    var customImageView: String?
    
    public init(title: String,
                subTitle: String? = nil,
                customImageView: String? = nil){
        self.title = title
        self.subTitle = subTitle
        self.customImageView = customImageView
    }
}

enum ProfileVersatileCardType: CaseIterable {
    case matches
    case survival
    case news
    
    static func getTypes(navigation: NavigationStats?) -> [ProfileVersatileCardType] {
        return navigation == .profile ? allCases : [.matches, .survival]
    }
    
    func getData(matchesCount: Int) -> VersatileCardRepresentable {
        switch self {
        case .matches:
            let text = matchesCount == 1 ? "versatilCardSubtitleMatch" : "versatilCardSubtitleMatches"
            return DefaultVersatilCard(title: "gamesPlayed".localize(),
                                       subTitle: text.localize().placeholderString(replace: .number, value: String(matchesCount)),
                                       customImageView: "matchesSerie")
        case .survival:
            return DefaultVersatilCard(title: "profileCardSurvival".localize(),
                                       subTitle: "profileCardSurvivalSubtitle".localize(),
                                       customImageView: "survivalSerie")
        case .news:
            return DefaultVersatilCard(title: "profileCardNews".localize(),
                                       subTitle: "profileCardNewsSubtitle".localize(),
                                       customImageView: "NewsSerie")
        }
    }
}
