//
//  UIView+Label.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 3/4/23.
//

import UIKit

extension UIView {
    
    func getTitleLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = ConstantFormat.smallFontBold
        label.numberOfLines = 0
        label.text = text
        return label
    }
}
