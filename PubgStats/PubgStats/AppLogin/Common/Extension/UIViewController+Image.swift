//
//  UIViewController+Image.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

extension UIViewController {
    func makeImageViewPersonal(name: String, data: Data?) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 40
        if let imageData = data {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = UIImage(named: name)
        }
        return imageView
    }
    func makeImageViewStats(name: String, height: CGFloat, label: UILabel) -> UIImageView {
        let imageView = UIImageView()
        //TODO: quitar cuando tenga todas las imagenes
        if name == "" {
            imageView.backgroundColor = .systemGray2
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.setHeightConstraint(with: height)
        imageView.layer.cornerRadius = 15
        imageView.image = UIImage(named: name)
        let text = label
        text.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(text)
        text.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        text.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        text.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        return imageView
    }
}

