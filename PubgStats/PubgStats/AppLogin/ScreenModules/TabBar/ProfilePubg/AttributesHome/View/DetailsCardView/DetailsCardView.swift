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
    
    func configureDetailsView(_ representable: AttributesViewRepresentable?) {
        self.representableDetails = representable
        createDetails()
        containerView.isHidden = true
        containerDetailsView.isHidden = false
        backgroundColor = .gray.withAlphaComponent(0.9)
        layer.cornerRadius = 8
    }
    
    func configureHomeView(_ representable: AttributesHome) {
        self.representableHome = representable
        createCards()
        containerView.isHidden = false
        containerDetailsView.isHidden = true
        let color: UIColor = representable.type == .survival ? .gray : .black
        backgroundColor = color.withAlphaComponent(0.8)
        layer.cornerRadius = 8
    }
}

private extension DetailsCardView {
    
    func createDetails() {
        representableDetails?.attributesHeaderDetails.sorted { $0.title < $1.title}.forEach({ data in
            let stack = getDetailsStack()
            let label = getTitleLabel()
            let percentageRectangleView = PercentageRectangleView()
            let newText = configureColor(data.title)
            label.attributedText = newText
            percentageRectangleView.configureView(DefaultPercentageRectangle(percentage: data.percentage,
                                                                             cornerRadius: 2,
                                                                             withText: false))
            percentageRectangleView.heightAnchor.constraint(equalToConstant: 4).isActive = true
            
            stack.addArrangedSubview(label)
            stack.addArrangedSubview(percentageRectangleView)
            detailsStackView.addArrangedSubview(stack)
        })
        let image = representableDetails?.type == .modeGames ? setType(representableDetails?.image ?? "")?.setImage() : representableDetails?.image
        imageView.image = UIImage(named: image ?? "")
    }
    
    func configureColor(_ text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let lastText = text.components(separatedBy: ":").last
        let attributedTitle = NSAttributedString(string: lastText ?? "", attributes: [
            .foregroundColor: ConstantFormat.colorDefault
        ])
        attributedString.append(NSAttributedString(string: text.replacingOccurrences(of: lastText ?? "", with: "")))
        attributedString.append(attributedTitle)
        return attributedString
    }
    
    func createCards() {
        guard let representable = representableHome else { return }
        let labelRectangle = representable.type.getRectangleHeaderLabel()
        let backgroundColor: UIColor = representable.type == .survival ? .black : .systemGray
        rectangleView.configureView(DefaultPercentageRectangle(text: labelRectangle,
                                                               percentage: representable.percentage,
                                                               backgroundColor: backgroundColor,
                                                               cornerRadius: 8,
                                                               withPercentageSymbol: representable.type == .modeGames))
        let image = representable.type == .modeGames ? setType(representable.image)?.setImage() : representable.image
        imageView.image = UIImage(named: image ?? "")
        leftLabel.text = representable.type.getLeftHeaderLabel()
        leftAmountLabel.text = "\(representable.leftAmount ?? 0)"
        rightLabel.text = representable.type.getRightHeaderLabel()
        rightAmountLabel.text = "\(representable.rightAmount ?? 0)"
        let title = representable.type == .modeGames ? setType(representable.title)?.setTitle() : representable.title
        titleLabel.text = title?.uppercased()
        titleLabel.textColor = ConstantFormat.colorDefault
    }
    
    func setType(_ mode: String) -> GamesModesTypes? {
        switch mode {
        case "solo": return .solo
        case "soloFpp": return .soloFpp
        case "duo": return .duo
        case "duoFpp": return .duoFpp
        case "squad": return .squad
        case "squadFpp": return .squadFpp
        default: return nil
        }
    }
}
