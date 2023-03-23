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
    private lazy var containerStackView = makeStack(space: 20)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Graduado en Programación de aplicaciones móviles con Swift en TokioSchool\n\nEsta aplicación ha sido creado con el objetivo de mostrar mis conocimientos adquiridos durante el curso y las prácticas curriculares en la entrega del TFM\n\nSi tienes alguna duda, sugerencia o problema con la ejecución de la app contacta a través de este correo:"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    private lazy var emailButton = makeButtonBlue(title: "Correo")
    
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let dependencies: ContactDependency
   
    init(dependencies: ContactDependency) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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



