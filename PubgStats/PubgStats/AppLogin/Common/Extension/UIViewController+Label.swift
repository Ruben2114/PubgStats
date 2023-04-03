//
//  UIViewController+Label.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 3/4/23.
//

import UIKit

extension UIViewController {
    func makeLabel(title: String, color: UIColor, font: CGFloat, style: UIFont.TextStyle ) -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: style)
        label.font = UIFont.systemFont(ofSize: font)
        label.textAlignment = .center
        label.textColor = color
        return label
    }
}
