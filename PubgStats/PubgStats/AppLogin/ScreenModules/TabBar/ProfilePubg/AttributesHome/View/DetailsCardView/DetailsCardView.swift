//
//  DetailsCardView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//


import UIKit
import Foundation

final class DetailsCardView: XibView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var containerDetailsView: UIView!
    @IBOutlet private weak var detailsStackView: UIStackView!
    @IBOutlet private weak var rectangleView: PercentageRectangleView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var leftAmountLabel: UILabel!
    @IBOutlet private weak var rightAmountLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!
    
    private var representableDetails: AttributesViewRepresentable?
    private var representableHome: AttributesHome?
    
    func configureDetailsView(_ representable: AttributesViewRepresentable) {
        self.representableDetails = representable
        createDetails()
        containerView.isHidden = true
        containerDetailsView.isHidden = false
    }
    
    func configureHomeView(_ representable: AttributesHome) {
        self.representableHome = representable
        createCards()
        containerView.isHidden = false
        containerDetailsView.isHidden = true
        backgroundColor = .black.withAlphaComponent(0.6)
        layer.cornerRadius = 8
    }
}

private extension DetailsCardView {
    
    func createDetails() {
        representableDetails?.attributesHeaderDetails.forEach({ data in
            let stack = getDetailsStack()
            let label = getTitleLabel(text: data.title)
            let percentageRectangleView = PercentageRectangleView()
            percentageRectangleView.configureView(percentage: data.percentage, cornerRadius: 4, withText: false)
            percentageRectangleView.heightAnchor.constraint(equalToConstant: 4).isActive = true
            
            stack.addArrangedSubview(label)
            stack.addArrangedSubview(percentageRectangleView)
            detailsStackView.addArrangedSubview(stack)
        })
        imageView.image = UIImage(named: representableDetails?.image ?? "")
    }
    
    func createCards() {
        guard let representable = representableHome else { return }
        let labelRectangle = representable.type.getRectangleHeaderLabel()
        rectangleView.configureView(text: labelRectangle, percentage: representable.percentage, cornerRadius: 8)
        imageView.image = UIImage(named: representable.image)
        leftLabel.text = representable.type.getLeftHeaderLabel()
        leftAmountLabel.text = "\(representable.leftAmount ?? 0)"
        rightLabel.text = representable.type.getRightHeaderLabel()
        rightAmountLabel.text = "\(representable.rightAmount ?? 0)"
        titleLabel.text = representable.title.uppercased()
        titleLabel.textColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
    }
}
