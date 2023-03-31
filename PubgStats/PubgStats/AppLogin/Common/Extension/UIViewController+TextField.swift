//
//  UIViewController+TextField.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

extension UIViewController {
    func makeTextField(placeholder: String, isSecure: Bool ) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .gray.withAlphaComponent(0.1)
        textField.placeholder = placeholder
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = isSecure
        return textField
    }
    func makeTextFieldLogin(placeholder: String, isSecure: Bool ) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = placeholder
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.layer.cornerRadius = 20
        textField.isSecureTextEntry = isSecure
        return textField
    }
    func makeTextFieldBorder(placeholder: String, isSecure: Bool ) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = placeholder
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemCyan.cgColor
        
        textField.isSecureTextEntry = isSecure
        return textField
    }
}
