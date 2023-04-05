//
//  UIViewController+Image.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

extension UIViewController {
    func makeImageViewPersonal(name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 40
        return imageView
    }

}
