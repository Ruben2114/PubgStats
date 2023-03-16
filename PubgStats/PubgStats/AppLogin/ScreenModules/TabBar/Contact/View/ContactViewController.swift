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
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray.withAlphaComponent(0.1)
        textField.placeholder = "tu mensaje"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 200).isActive = true
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.layer.cornerRadius = 10
        return textField
    }()
    private let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Accept", for: .normal)
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
        title = "Login"
    }
    private func configConstraints() {
        contentView.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        [titleLabel,textField, acceptButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    private func configTargets() {
        acceptButton.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
    }
    
    @objc func didTapAcceptButton() {
        guard MFMailComposeViewController.canSendMail() else{
            return
        }
        let sendMail = MFMailComposeViewController()
        sendMail.setToRecipients(["cervigon21@gmail.com"])
        sendMail.setSubject("Correo de prueba")
        guard let text = textField.text, !text.isEmpty else { return}
        sendMail.setMessageBody(text, isHTML: true)
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



