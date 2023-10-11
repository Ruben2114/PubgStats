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
    func makeStackImage(space: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = space
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }
    func createStackHorizontalButton(space: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = space
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
}

extension UIView {
    func createStack() -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 5
         stack.axis = .vertical
         stack.alignment = .center
         stack.translatesAutoresizingMaskIntoConstraints = false
         return stack
    }
}
