//
//  MessageDisplayable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import UIKit
protocol MessageDisplayable { }

extension MessageDisplayable where Self: UIViewController{
    func presentAlert(message: String, title: String){
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "actionAccept".localize(), style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    func presentAlertTimer(message: String, title: String, timer: Double){
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        self.present(alertController, animated: true)
        Timer.scheduledTimer(withTimeInterval: timer, repeats: false) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
    }
   
    func presentAlertTextField(title: String, message: String, textFields: [(title: String, placeholder: String)], completed: ((_ text: [String]) -> Void)? = nil, isSecure: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for text in textFields {
            alert.addTextField { (textField) in
                textField.placeholder = text.placeholder
                textField.isSecureTextEntry = isSecure
            }
        }
        let actionAccept = UIAlertAction(title: "actionAccept".localize(), style: .default) { _ in
            var texts: [String] = []
            for textField in alert.textFields ?? [] {
                if let text = textField.text {
                    texts.append(text)
                }
            }
            completed?(texts)
        }
        let actionCancel = UIAlertAction(title: "actionCancel".localize(), style: .destructive)
        alert.addAction(actionCancel)
        alert.addAction(actionAccept)
        present(alert, animated: true)
    }
}
