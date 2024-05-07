//
//  MatchesTableViewCell.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 9/4/24.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var mapImageView: UIImageView!
    @IBOutlet private weak var mapLabel: UILabel!
    @IBOutlet private weak var gameModeLabel: UILabel!
    @IBOutlet private weak var killsLabel: UILabel!
    @IBOutlet private weak var damageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setViewAppearance()
    }
    
    func configureWith(representable: MatchRepresentable) {
        configureViews(representable)
    }
}

private extension MatchesTableViewCell {
    func setViewAppearance() {
        containerView.layer.cornerRadius = 8
        gameModeLabel.textColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        positionLabel.textColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        positionLabel.contentHuggingPriority(for: .horizontal)
        positionLabel.setContentHuggingPriority(.required, for: .horizontal)
        mapLabel.contentHuggingPriority(for: .horizontal)
        mapLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    func configureViews(_ representable: MatchRepresentable) {
        dateLabel.text = representable.date?.formatted()
        dateLabel.isHidden = representable.date == nil ? true : false
        mapImageView.image = UIImage(named: representable.map) ?? UIImage(named: "Baltic_Main")
        mapLabel.text = setMapText(representable.map)
        gameModeLabel.text = configureGamesMode(representable.gameMode).localize().capitalized
        killsLabel.text = "\("Kills".localize()): \(representable.kills)"
        damageLabel.text = String(format: "\("damage".localize()): %.0f", representable.damage)
        positionLabel.text = String(representable.position)
    }
    
    func setMapText(_ text: String) -> String {
        let splitText = text.components(separatedBy:  "_")
        return splitText.first ?? text
    }
    
    func configureGamesMode(_ mode: String) -> String {
        if mode.contains("-") {
            let newMode = mode.replacingOccurrences(of: "-", with: "")
            if let firstIndex = mode.firstIndex(of: "-") {
                let nextIndex = mode.index(after: firstIndex)
                let modeUppercased = mode[nextIndex].uppercased()
                return newMode.replacingCharacters(in: firstIndex..<nextIndex, with: modeUppercased)
            }
        }
        return mode
    }
}
