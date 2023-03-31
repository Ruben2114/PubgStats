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
        let okAction = UIAlertAction(title: "Ok", style: .default)
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
}
