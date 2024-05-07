//
//  AttributesHomeViewCell.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 3/2/24.
//

import UIKit

class AttributesHomeViewCell: UITableViewCell {
    private lazy var detailsCardView: DetailsCardView = {
        let detailsCardView = DetailsCardView()
        contentView.addSubview(detailsCardView)
        detailsCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsCardView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            detailsCardView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            detailsCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            detailsCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        return detailsCardView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWith(representable: AttributesHome) {
        detailsCardView.configureHomeView(representable)
    }
}
