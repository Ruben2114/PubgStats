//
//  PruebaViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import MessageUI
import UIKit

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    func enviarCorreo() {
        let password = "0000"
        let destinatario = "cervigon21@gmail.com"
        let asunto = "Contraseña de usuario"
        let mensaje = "Su contraseña es: \(password)"
        let remitente = "rubenro2114@gmail.com"
        
        if MFMailComposeViewController.canSendMail() {
            let emailController = MFMailComposeViewController()
            emailController.mailComposeDelegate = self
            emailController.setPreferredSendingEmailAddress(remitente)
            emailController.setToRecipients([destinatario])
            emailController.setSubject(asunto)
            emailController.setMessageBody(mensaje, isHTML: false)
            self.present(emailController, animated: true) {
                emailController.view.removeFromSuperview()
            }
        } else {
            print("El dispositivo no está configurado para enviar correos electrónicos")
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

