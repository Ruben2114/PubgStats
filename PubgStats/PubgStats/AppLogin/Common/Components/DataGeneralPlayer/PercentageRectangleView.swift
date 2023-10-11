//
//  PercentageRectangleView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/7/23.
//

import UIKit

class PercentageRectangleView: UIView {
    private let fillLayer = CALayer()
    var percentage: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        configUI()
        label.text = "Victorias \(percentage) %"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width * (percentage / 100)
        fillLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: width, height: bounds.size.height)
    }
    
    private func configUI() {
        fillLayer.backgroundColor = UIColor.orange.cgColor
        self.layer.addSublayer(fillLayer)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
