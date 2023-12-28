//
//  ChartCollectionViewCell.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 17/7/23.
//

import UIKit
import Foundation

protocol ChartCollectionViewCellDelegate: AnyObject {
    func didTapTooltip()
}

class ChartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var interacticeChartView: InteractiveSectoredPieChartView!
    @IBOutlet private weak var customContentView: UIView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var helpImageView: UIImageView!
    
    private var representable: PieChartViewDataRepresentable?
    weak var delegate: ChartCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setDefaultConfiguration()
    }
    
    func configureWith(viewData: PieChartViewDataRepresentable) {
        self.representable = viewData
        configureViews()
        interacticeChartView.setChartInfoInteractive(viewData)
        interacticeChartView.build()
    }
    
    func didTapNewView(_ gesture: UIPanGestureRecognizer) {
        interacticeChartView.didTapNewView(gesture)
    }
}

private extension ChartCollectionViewCell {
    func setupView() {
        customContentView.tag = 1
        interacticeChartView.tag = 2
        setViewAppearence()
    }
    
    func configureViews() {
        infoLabel.text = representable?.tooltipLabelTextKey ?? ""
        helpImageView.isUserInteractionEnabled = true
        helpImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTooltip)))
    }
    
    func setViewAppearence() {
        customContentView.layer.cornerRadius = 8
        customContentView.layer.borderColor = UIColor.systemGray3.cgColor
        customContentView.backgroundColor = .white
        customContentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        customContentView.layer.shadowOpacity = 0.2
    }
    
    func setDefaultConfiguration() {
        infoLabel.text = ""
    }
    
    @objc func didTapTooltip() {
        delegate?.didTapTooltip()
    }
}
