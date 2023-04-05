//
//  UIView+Constraint.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import UIKit

extension UIView {
    func setConstraints(
        top: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        pTop: CGFloat = CGFloat.zero,
        pRight: CGFloat = CGFloat.zero,
        pBottom: CGFloat = CGFloat.zero,
        pLeft: CGFloat = CGFloat.zero
    ){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: pTop).isActive = true
        }
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -pRight).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -pBottom).isActive = true
        }
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant: pLeft).isActive = true
        }
    }
    func fillSuperView(widthPadding: CGFloat = .zero){
        guard let superView = self.superview else {return}
        setConstraints(
            top: superView.topAnchor,
            right: superView.rightAnchor,
            bottom: superView.bottomAnchor,
            left: superView.leftAnchor,
            pTop: widthPadding,
            pRight: widthPadding,
            pBottom: widthPadding,
            pLeft: widthPadding)
    }
    func centerY(){
        guard let superview = self.superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
    func centerX(){
        guard let superview = self.superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }
    func centerXY(){
        centerY()
        centerX()
    }
    
    func setHeightConstraint(with height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    func setWidthConstraint(with width: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
