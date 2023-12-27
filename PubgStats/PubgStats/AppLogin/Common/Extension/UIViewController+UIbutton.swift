//
//  UIViewController+UIbutton.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

extension UIViewController {
    func makeButtonClear(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemCyan, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 15
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return button
    }
    func makeButtonBlue(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemCyan
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    func makeButtonBlue2(title: String, height: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemCyan
        button.setHeightConstraint(with: height)
        return button
    }
    func makeButtonCorner(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.systemCyan.cgColor
        button.layer.borderWidth = 2
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    func createButtonStack(title: String, selector: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 10
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}
