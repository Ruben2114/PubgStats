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
    func makeLabelProfile(title: String, color: UIColor, font: CGFloat, style: UIFont.TextStyle, isBold: Bool) -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: style)
        if isBold {
            label.font = UIFont.boldSystemFont(ofSize: font)
        } else{
            label.font = UIFont.systemFont(ofSize: font)
        }
        label.textAlignment = .left
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    func makeLabelStats(height: CGFloat) -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.setHeightConstraint(with: height)
        return label
    }
    func makeLabelStatsLevel(height: CGFloat, width: CGFloat) -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.setHeightConstraint(with: height)
        label.setWidthConstraint(with: width)
        let image = UIImage(named: "default")
        label.backgroundColor = UIColor(patternImage: image!)
        label.clipsToBounds = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = height / 2
        return label
    }
    func makeLabelStatsBoder(height: CGFloat) -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.setHeightConstraint(with: height)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 15
        return label
    }
    func makeLabelImage() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
}
