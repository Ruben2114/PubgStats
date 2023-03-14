//
//  RegisterViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import UIKit
import Combine

protocol RegisterViewControllerCoordinator {
    func didTapAcceptButton()
}

class RegisterViewController: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: RegisterViewModel
    private let coordinator: RegisterViewControllerCoordinator
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register on AppPubgStats"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    private lazy var userTextField = makeTextField(placeholder: "User Name")
    private lazy var passwordTextField = makeTextField(placeholder: "Password")
    
    //TODO: como ponerle el weak para no perder memoria
    var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Accept"
        configuration.buttonSize = .small
        configuration.titleAlignment = .center
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }
        button.configuration = configuration
        return button
    }()
    
    init(coordinator: RegisterViewControllerCoordinator, viewModel: RegisterViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUserInterface()
        configTargets()
    }
    
    private func configUserInterface(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(containerView)
        containerView.setConstraints(
            top: view.topAnchor,
            right: view.rightAnchor,
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            pTop: 250)
        
        containerView.addSubview(titleLabel)
        titleLabel.setConstraints(
            top: containerView.topAnchor,
            right: containerView.rightAnchor,
            left: containerView.leftAnchor,
            pTop: 20)
        
        containerView.addSubview(userTextField)
        userTextField.setConstraints(
            top: titleLabel.bottomAnchor,
            right: containerView.rightAnchor,
            left: containerView.leftAnchor,
            pTop: 40,
            pRight: 20,
            pLeft: 20)
        
        containerView.addSubview(passwordTextField)
        passwordTextField.setConstraints(
            top: userTextField.bottomAnchor,
            right: containerView.rightAnchor,
            left: containerView.leftAnchor,
            pTop: 25,
            pRight: 20,
            pLeft: 20)
        containerView.addSubview(acceptButton)
        acceptButton.setConstraints(
            top: passwordTextField.bottomAnchor,
            right: containerView.rightAnchor,
            left: containerView.leftAnchor,
            pTop: 25,
            pRight: 20,
            pLeft: 20)
    }
    
    
    private func configTargets() {
        acceptButton.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
    }
    
    
    private func makeTextField(placeholder: String) -> UITextField {
        let text = UITextField()
        text.placeholder = placeholder
        text.adjustsFontSizeToFitWidth = true
        text.textAlignment = .center
        text.borderStyle = .line
        return text
    }
    //TODO: como meto aqui combine
    @objc func didTapAcceptButton() {
        //TODO: OBLIGAR A QUE LA CONTRASEÑA TENGA X CARACTERISTICAS
        let nameText = userTextField.text
        let passwordText = passwordTextField.text
        guard !nameText!.isEmpty, !passwordText!.isEmpty else {
            presentAlert(message: "Please, fill in all fields", title: "Error")
            return
        }
        guard viewModel.checkIfNameExists(name: userTextField.text!) != true else {
            presentAlert(message: "This user already exists", title: "Error")
            return
        }
        viewModel.saveUser(name: nameText ?? "", password: passwordText ?? "")
        coordinator.didTapAcceptButton()
    }
}
extension RegisterViewController: MessageDisplayable { }



