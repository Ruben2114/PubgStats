//
//  AttributesDetailsCollectionViewCell.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

final class AttributesDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    private var representable: AttributesDetails?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setContainerAppearence()
    }

    func configureWith(_ representable: AttributesDetails?) {
        self.representable = representable
        configureLabels()
    }
}

private extension AttributesDetailsCollectionViewCell {
    func configureLabels() {
        titleLabel.text = representable?.title
        subtitleLabel.text = representable?.amount
    }
    
    func setContainerAppearence() {
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .black.withAlphaComponent(0.6)
    }
}
