//
//  UIView+Constraint.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import UIKit

extension UIView {
    
    func fillSuperView(widthPadding: CGFloat = .zero){
        guard let superView = self.superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
    }
    
    func centerXY(){
        guard let superview = self.superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }
    
    func setHeightConstraint(with height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func embedIntoView(topMargin: CGFloat = 0, bottomMargin: CGFloat = 0, leftMargin: CGFloat = 0, rightMargin: CGFloat = 0) -> UIView {
        let container = UIView()
        container.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: container.leftAnchor, constant: leftMargin),
            self.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -rightMargin),
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: topMargin),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -bottomMargin)
        ])
        return container
    }
}
