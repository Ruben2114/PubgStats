//
//  ContactViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import Combine
import MessageUI

final class ContactViewController: UIViewController {
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Graduado en Programación de aplicaciones móviles con Swift en TokioSchool\n\nEsta aplicación ha sido creado con el objetivo de mostrar mis conocimientos adquiridos durante el curso y las prácticas curriculares en la entrega del TFM\n\nSi tienes alguna duda, sugerencia o problema con la ejecución de la app contacta a través de este correo:"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    
    private let emailButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Correo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScroll()
        configUI()
        configConstraints()
        configTargets()
        configKeyboardSubscription(mainScrollView: mainScrollView)
        hideKeyboard()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Contact"
    }
    private func configConstraints() {
        contentView.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100).isActive = true
        containerStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        [titleLabel, emailButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    private func configTargets() {
        emailButton.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
    }
    
    @objc func didTapEmailButton() {
        guard MFMailComposeViewController.canSendMail() else{
            return
        }
        let sendMail = MFMailComposeViewController()
        sendMail.setToRecipients(["cervigon21@gmail.com"])
        sendMail.setSubject("Correo de prueba")
        sendMail.setMessageBody("", isHTML: true)
        sendMail.mailComposeDelegate = self
        present(sendMail, animated: true, completion: nil)
    }
}


extension ContactViewController: ViewScrollable {}
extension ContactViewController: KeyboardDisplayable {}
extension ContactViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        guard error == nil else{
            print("Ha ocurrido un problema")
            return
        }
        switch result{
        case .cancelled:
            print("Cancelado")
        case .saved:
            print("Guardado")
        case .sent:
            print("Enviado con éxito")
        case .failed:
            print("Ha fallado")
        @unknown default:
            print("Error inesperado")
        }
    }
}



