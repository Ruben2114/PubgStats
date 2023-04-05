//
//  UIViewController+Stack.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

extension UIViewController {
    func makeStack(space: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = space
        return stack
    }
    func makeStackHorizontal(space: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = space
        return stack
    }
}
