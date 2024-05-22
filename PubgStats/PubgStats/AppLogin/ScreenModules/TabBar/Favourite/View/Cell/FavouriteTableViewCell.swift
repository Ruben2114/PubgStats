//
//  FavouriteTableViewCell.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 19/3/24.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var playerLabel: UILabel!
    @IBOutlet private weak var platformLogo: UIImageView!
    
    private var representable: IdAccountDataProfileRepresentable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setViewAppearence()
    }

    func configureWith(_ representable: IdAccountDataProfileRepresentable) {
        self.representable = representable
        configureViews()
    }
    
    func getHeightContainer() -> CGFloat {
        containerView.frame.height
    }
}

private extension FavouriteTableViewCell {
    func setViewAppearence() {
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .black.withAlphaComponent(0.9)
    }
    
    func configureViews() {
        playerLabel.text = representable?.name
        let logo = representable?.platform == "steam" ? "Steam_icon_logo" : "Xbox_icon_logo"
        platformLogo.image = UIImage(named: logo)
    }
}
