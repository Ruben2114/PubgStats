//
//  MessageDisplayable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import UIKit
protocol MessageDisplayable { }

enum AlertActionTypes {
    case accept((() -> Void)?)
    case retry((() -> Void)?)
    case cancel((() -> Void)?)
    
    func setTitle() -> String {
        switch self {
        case .accept:
            "actionAccept".localize()
        case .retry:
            "actionRetry".localize()
        case .cancel:
            "actionCancel".localize()
        }
    }
}

extension MessageDisplayable where Self: UIViewController{
  
    func presentAlert(message: String, title: String, action: [AlertActionTypes]){
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        action.forEach { type in
            alertController.addAction(UIAlertAction(title: type.setTitle(), style: .default) { _ in
                switch type {
                case .accept(let action):
                    action?()
                case .retry(let action):
                    action?()
                case .cancel(let action):
                    action?()
                }
            })
        }
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
