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
    
    private var representable: AttributesViewRepresentable?
    
    func configureView(_ representable: AttributesViewRepresentable) {
        self.representable = representable
        if representable.isDetails {
            createDetails()
            containerView.isHidden = true
            containerDetailsView.isHidden = false
        } else {
            createCards()
            containerView.isHidden = false
            containerDetailsView.isHidden = true
            self.backgroundColor = .black.withAlphaComponent(0.6)
            self.layer.cornerRadius = 8
        }
    }
}

private extension DetailsCardView {
    
    func createDetails() {
        representable?.attributesHeaderDetails.forEach({ data in
            let stack = getDetailsStack()
            let label = getTitleLabel(text: data.title)
            let percentageRectangleView = PercentageRectangleView()
            percentageRectangleView.configureView(percentage: data.percentage, cornerRadius: 4, withText: false)
            percentageRectangleView.heightAnchor.constraint(equalToConstant: 4).isActive = true
            
            stack.addArrangedSubview(label)
            stack.addArrangedSubview(percentageRectangleView)
            detailsStackView.addArrangedSubview(stack)
        })
        imageView.image = UIImage(named: representable?.attributesHome.image ?? "")
    }
    
    func createCards() {
        guard let representable = representable?.attributesHome else { return }
        let labelRectangle = self.representable?.type.getRectangleHeaderLabel() ?? ""
        rectangleView.configureView(text: labelRectangle, percentage: representable.percentage, cornerRadius: 8)
        imageView.image = UIImage(named: representable.image)
        leftLabel.text = self.representable?.type.getLeftHeaderLabel()
        leftAmountLabel.text = "\(representable.leftAmount ?? 0)"
        rightLabel.text = self.representable?.type.getRightHeaderLabel()
        rightAmountLabel.text = "\(representable.rightAmount ?? 0)"
        titleLabel.text = self.representable?.title.uppercased()
        titleLabel.textColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
    }
}

//TODO: llevar esto a la extension
extension UIView {
    func getTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 16)
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    func getDetailsStack() -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 2
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }
    
    public func embedIntoView(topMargin: CGFloat = 0, bottomMargin: CGFloat = 0, leftMargin: CGFloat = 0, rightMargin: CGFloat = 0) -> UIView {
        let container = UIView()
        container.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: container.leftAnchor, constant: leftMargin),
            self.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -rightMargin),
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: topMargin),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -bottomMargin)
        ])
        return container
    }
}
