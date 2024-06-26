//
//  UIViewController+UIbutton.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

extension UIViewController {
   
    func createButtonImage(image: UIImage?, selector: Selector) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = ConstantFormat.colorDefault
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.imageView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}
