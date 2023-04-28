//
//  UIViewController+BackButton.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

extension UIViewController {
    func backButton(action: Selector?) {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward.circle.fill"), style: .plain, target: self, action: action)
        navigationItem.leftBarButtonItem = backButton
    }
    func legendButton() -> UIButton  {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "list.bullet.circle.fill"), for: .normal)
        let wins = UIAction(title: "playerStatsV".localize() + " = " + "playerStatsVLabel".localize()) { _ in}
        let losses = UIAction(title: "playerStatsD".localize() + " = " + "playerStatsDLabel".localize()) { _ in}
        let headshotKills = UIAction(title: "playerStatsMD".localize() + " = " + "playerStatsMDLabel".localize()) { _ in}
        let kills = UIAction(title: "playerStatsK".localize() + " = " + "playerStatsKLabel".localize()) { _ in}
        let top10 = UIAction(title: "playerStatsT".localize() + " = " + "playerStatsTLabel".localize()) { _ in}
     
        let menu = UIMenu(title: "Opciones", children: [wins, losses, headshotKills, kills, top10])
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        return button
    }
}
