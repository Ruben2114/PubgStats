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
        label.font = UIFont.systemFont(ofSize: 16)
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
    //TODO: meterlo en un struct
    func configureView(text: String = "", percentage: CGFloat, backgroundColor: UIColor = .black, cornerRadius: CGFloat = 0, withText: Bool = true) {
        if withText {
            let percentageLabel = String(format: "%.0f", percentage)
            self.label.text = "\(text) \(percentageLabel) %"
        }
        self.percentage = percentage
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        fillLayer.cornerRadius = cornerRadius
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
