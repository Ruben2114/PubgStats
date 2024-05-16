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
        if representable?.platform == "steam" {
            platformLogo.image = UIImage(named: "Steam_icon_logo")
        }
    }
}
