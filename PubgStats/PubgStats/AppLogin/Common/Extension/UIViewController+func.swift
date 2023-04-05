//
//  UIViewController+func.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 4/4/23.
//

import Foundation
import UIKit

extension UIViewController {
    func checkValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let check = emailPredicate.evaluate(with: email)
        return check
    }
}
