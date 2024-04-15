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
//        let attributedTitle = NSAttributedString(string: title, attributes: [
//            .font: UIFont(name: "AmericanTypewriter-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)
//        ])
//        let attributedMessage = NSAttributedString(string: message, attributes: [
//            .font: UIFont(name: "AmericanTypewriter", size: 16) ?? UIFont.systemFont(ofSize: 16)
//        ])
//        alertController.setValue(attributedTitle, forKey: "attributedTitle")
//        alertController.setValue(attributedMessage, forKey: "attributedMessage")
//        alertController.view.tintColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        //TODO: aclarar lo del color
        let okAction = UIAlertAction(title: "actionAccept".localize(), style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func presentAlertOutOrRetry(message: String, title: String, completion: (() -> Void)?){
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "actionCancel".localize(), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "actionRetry".localize(), style: .default) { _ in
            completion?()
        })
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
   
    func presentAlertPlatform(title: String, message: String? = nil, completed: ((_ platform: String) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "actionCancel".localize(), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Steam", style: .default, handler: { (action) in
            completed?("steam")
        }))
        alertController.addAction(UIAlertAction(title: "Xbox", style: .default, handler: { (action) in
            completed?("xbox")
        }))
        present(alertController, animated: true)
    }
}
