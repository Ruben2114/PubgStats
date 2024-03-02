//
//  Chip.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 19/10/23.
//

import Foundation
import UIKit
import Combine

public final class Chip: FlameXibButton {
    @IBOutlet private weak var roundedView: UIView!
    @IBOutlet private weak var textLabel: UILabel?
    
    private var subject = PassthroughSubject<Void, Never>()
    public lazy var publisher: AnyPublisher<Void, Never> = {
        return subject.eraseToAnyPublisher()
    }()
        
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    
    func setViewData(text: String) {
        self.textLabel?.text = text
    }
}

private extension Chip {
    func configureView() {
        roundedView.isUserInteractionEnabled = true
        roundedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapInsideChip)))
        setStyleAppearance()
        setCornerRadius()
    }
    
    func setStyleAppearance() {
        textLabel?.textColor = .white
        roundedView.backgroundColor = .systemGray
        roundedView.layer.borderColor = UIColor(red: 0.075, green: 0.494, blue: 0.518, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.systemGray.cgColor
    }
    
    func setCornerRadius() {
        layoutIfNeeded()
        roundedView.layer.cornerRadius = self.roundedView.frame.height/2
    }
    
    @objc func tapInsideChip() {
        subject.send()
    }
}
