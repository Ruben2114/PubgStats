//
//  ProfileGeneralView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 17/12/23.
//

import UIKit
import Foundation

final class ProfileGeneralView: XibView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var winsLabel: UILabel!
    @IBOutlet private weak var winsAmount: UILabel!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var topAmount: UILabel!
    @IBOutlet private weak var gamesPlayedLabel: UILabel!
    @IBOutlet private weak var gamesPlayedAmount: UILabel!
    @IBOutlet private weak var killsLabel: UILabel!
    @IBOutlet private weak var killsAmount: UILabel!
    @IBOutlet private weak var headshotLabel: UILabel!
    @IBOutlet private weak var headshotAmount: UILabel!
    @IBOutlet private weak var assistsLabel: UILabel!
    @IBOutlet private weak var assistsAmount: UILabel!
    @IBOutlet private weak var percentageView: PercentageRectangleView!
    
    private var representable: GamesModesDataProfileRepresentable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureView(_ representable: GamesModesDataProfileRepresentable) {
        self.representable = representable
        configureView()
    }
}

private extension ProfileGeneralView {
    func configureViews() {
        configureContainer()
    }
    
    func configureContainer() {
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    func configureView() {
        guard let representable else { return }
        let percentage = representable.wonTotal != 0 && representable.gamesPlayed != 0 ? CGFloat(Double(representable.wonTotal) / Double(representable.gamesPlayed) * 100) : 0
        titleLabel.text = getTitle(percentage)
        winsLabel.text = "wins".localize()
        winsAmount.text = String(representable.wonTotal)
        topLabel.text = "Top 10"
        topAmount.text = String(representable.top10STotal)
        gamesPlayedLabel.text = "rounds".localize()
        gamesPlayedAmount.text = String(representable.gamesPlayed)
        killsLabel.text = "Kills".localize()
        killsAmount.text = String(representable.killsTotal)
        headshotLabel.text = "HeadShots".localize()
        headshotAmount.text = String(representable.headshotKillsTotal)
        assistsLabel.text = "assists".localize()
        assistsAmount.text = String(representable.assistsTotal)
        percentageView.configureView(DefaultPercentageRectangle(text: "wins".localize(),
                                                                percentage: percentage,
                                                                backgroundColor: .systemGray,
                                                                cornerRadius: 8,
                                                                withPercentageSymbol: true))
    }
    
    func getTitle(_ level: CGFloat) -> String {
        switch level {
        case 0..<20: return "Rookie".localize()
        case 20..<40: return "Private".localize()
        case 40..<60: return "Sergeant".localize()
        case 60..<80: return "Captain".localize()
        case 80..<100: return "Legend".localize()
        default:
            return "Apprentice".localize()
        }
    }
}
