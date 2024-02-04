//
//  DataGeneralView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 17/12/23.
//

import UIKit
import Foundation
import Combine

final class DataGeneralView: XibView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var chevronButton: UIButton!
    @IBOutlet private weak var totalStackView: UIStackView!
    @IBOutlet private weak var gamesPlayedLabel: UILabel!
    @IBOutlet private weak var wonLabel: UILabel!
    @IBOutlet private weak var medalImageView: UIImageView!
    @IBOutlet private weak var percentageRectangleView: PercentageRectangleView!
    
    var state: ResizableState = .colapsed
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension DataGeneralView {
    func configureViews() {
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.systemGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.2
        
        chevronButton.isUserInteractionEnabled = true
        chevronButton.setImage(UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), for: .normal)
        chevronButton.addTarget(self, action: #selector(toggleState), for: .touchUpInside)
        chevronButton.layer.cornerRadius = chevronButton.frame.height / 2.0
        chevronButton.layer.borderColor = UIColor.systemGray.cgColor
        chevronButton.layer.borderWidth = 1
        
        medalImageView.image = UIImage(systemName: "medal")
        gamesPlayedLabel.text = "Partidas: 200"
        wonLabel.text = "Victorias: 200"
        
//        percentageRectangleView.percentage = 20
//        percentageRectangleView.label.text = "Victorias 20 %"

        isHiddenTotalStackView(true)
    }
    
    func isHiddenTotalStackView(_ isHidden: Bool) {
        totalStackView.subviews.forEach { view in
            view.isHidden = isHidden
        }
    }
    
    @objc private func toggleState() {
        let angle: Double
        switch self.state {
        case .colapsed:
            self.state = .expanded
            isHiddenTotalStackView(false)
            angle = .pi
        case .expanded:
            self.state = .colapsed
            isHiddenTotalStackView(true)
            angle = -2*Double.pi
        }
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.chevronButton.transform = CGAffineTransform(rotationAngle: angle)
        })
    }
}
