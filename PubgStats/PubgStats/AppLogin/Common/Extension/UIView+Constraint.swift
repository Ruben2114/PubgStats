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
    
    func embedIntoCenter() -> UIView {
        let container = UIView()
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        return container
    }
    
    @discardableResult
    func roundCorners(corners: UIRectCorner,
                      radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        return mask
    }

    func getTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 16)
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    func getDetailsStack() -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 2
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
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

extension CGRect {
    init(centeredOn center: CGPoint, size: CGSize) {
        self.init( origin: CGPoint(x: center.x - size.width/2, y: center.y - size.height/2), size: size)
    }
    
    var center: CGPoint {
        CGPoint(x: origin.x + size.width/2, y: origin.y + size.height/2)
    }
}
