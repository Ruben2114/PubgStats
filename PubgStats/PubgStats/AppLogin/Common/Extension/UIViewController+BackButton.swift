//
//  UIViewController+BackButton.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

extension UIViewController {
    func backButton(action: Selector?) {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward.circle.fill"), style: .plain, target: self, action: action)
        navigationItem.leftBarButtonItem = backButton
    }
}
