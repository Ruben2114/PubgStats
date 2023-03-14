//
//  HomeMenuViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import UIKit
import Combine

protocol HomeMenuViewControllerCoordinator {
    func didTapLoginButton()
    func didTapRegisterButton()
}

class HomeMenuViewController: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: HomeMenuViewModel
    private let coordinator: HomeMenuViewControllerCoordinator
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to AppPubgStats"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    private lazy var userTextField = makeTextField(placeholder: "User Name")
    private lazy var passwordTextField = makeTextField(placeholder: "Password")
    private lazy var loginButton: UIButton = makeTitleBlueButton(
        title: "Login")
    private lazy var registerButton: UIButton = makeTitleBlueButton(
        title: "Register")
    init(coordinator: HomeMenuViewControllerCoordinator, viewModel: HomeMenuViewModel) {
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
        let buttonStackView = UIStackView(
            arrangedSubviews: [loginButton, registerButton])
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 25
        containerView.addSubview(buttonStackView)
        buttonStackView.setConstraints(
            top: passwordTextField.bottomAnchor,
            right: containerView.rightAnchor,
            left: containerView.leftAnchor,
            pTop: 40,
            pRight: 20,
            pLeft: 20)
    }
    private func configTargets() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    private func makeTextField(placeholder: String) -> UITextField {
        let text = UITextField()
        text.placeholder = placeholder
        text.adjustsFontSizeToFitWidth = true
        text.textAlignment = .center
        text.borderStyle = .line
        return text
    }
    private func makeTitleBlueButton(
        title: String
    ) -> UIButton {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
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
    }
    @objc func didTapLoginButton() {
        
        guard viewModel.checkName(name: userTextField.text ?? "", password: passwordTextField.text ?? "") == true else {
            presentAlert(message: "Incorrect username or password.", title: "Error")
            return
        }
        coordinator.didTapLoginButton()
    }
    @objc func didTapRegisterButton() {
        coordinator.didTapRegisterButton()
    }
}
extension HomeMenuViewController: MessageDisplayable { }


