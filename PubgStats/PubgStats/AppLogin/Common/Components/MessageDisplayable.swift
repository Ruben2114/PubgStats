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
        let okAction = UIAlertAction(title: "Aceptar", style: .default)
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
   
    func presentAlertTextField(title: String, message: String, textFields: [(title: String, placeholder: String)], action: (() -> Void)? = nil, completed: ((_ text: [String]) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for text in textFields {
            alert.addTextField { (textField) in
                textField.placeholder = text.placeholder
            }
        }
        let actionAccept = UIAlertAction(title: "Aceptar", style: .default) { _ in
            var texts: [String] = []
            for textField in alert.textFields ?? [] {
                if let text = textField.text {
                    texts.append(text)
                }
            }
            completed?(texts)
            action?()
        }
        let actionCancel = UIAlertAction(title: "cancelar", style: .destructive)
        alert.addAction(actionCancel)
        alert.addAction(actionAccept)
        present(alert, animated: true)
    }
}
