//
//  UIViewController+BackButton.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

extension UIViewController {
    func titleNavigation(_ title: String?, backButton: Selector? = nil) {
        navigationItem.title = title?.localize()
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1),
            .font : UIFont(name: "AmericanTypewriter-Bold", size: 20) ?? UIFont.systemFont(ofSize: 16)
        ]
        if backButton != nil {
            let backButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward.circle.fill"), style: .plain, target: self, action: backButton)
            backButton.tintColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    func configureImageBackground(_ image: String) {
        let imageBackground = UIImageView(image: UIImage(named: image))
        view.insertSubview(imageBackground, at: 0)
        imageBackground.frame = view.bounds
    }
}
