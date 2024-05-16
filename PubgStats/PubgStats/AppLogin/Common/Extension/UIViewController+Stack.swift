//
//  UIViewController+Stack.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

extension UIViewController {
    
    func createStackHorizontalButton(space: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = space
        return stack
    }
}

extension UIView {
    
    func getDetailsStack() -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 2
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }
}
