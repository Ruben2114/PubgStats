//
//  PercentageRectangleView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/7/23.
//

import UIKit

class PercentageRectangleView: UIView {
    private let fillLayer = CALayer()
    private var percentage: CGFloat = 0
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "AmericanTypewriter", size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }

    func configureView(_ data: PercentageRectangleRepresentable) {
        if data.withText == true {
            let percentageLabel = String(format: "%.0f", data.percentage)
            let percentageSymbol = data.withPercentageSymbol == true ? "%" : ""
            self.label.text = "\(data.text ?? "") \(percentageLabel) \(percentageSymbol)"
        }
        self.percentage = data.percentage
        self.backgroundColor = data.backgroundColor
        self.layer.cornerRadius = data.cornerRadius ?? 0
        fillLayer.cornerRadius = data.cornerRadius ?? 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width * (percentage / 100)
        fillLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: width, height: bounds.size.height)
    }
    
    private func configUI() {
        fillLayer.backgroundColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1).cgColor
        self.layer.addSublayer(fillLayer)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
