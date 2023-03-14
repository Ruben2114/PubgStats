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
    func didTapForgotButton()
    func didTapRegisterButton()
}

class HomeMenuViewController: UIViewController {
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: HomeMenuViewModel
    private let coordinator: HomeMenuViewControllerCoordinator
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pubgHome")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return imageView
    }()
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var userTextField = makeTextField(placeholder: "User Name", isSecure: false)
    private lazy var passwordTextField = makeTextField(placeholder: "Password", isSecure: true)
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    private lazy var forgotPasswordButton: UIButton = makeTitleButton(
        title: "forgot your password?")
    private lazy var registerButton: UIButton = makeTitleButton(
        title: "Sign Up")
    
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), viewModel: HomeMenuViewModel, coordinator: HomeMenuViewControllerCoordinator) {
        self.mainScrollView = mainScrollView
        self.contentView = contentView
        self.cancellable = cancellable
        self.viewModel = viewModel
        self.coordinator = coordinator
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
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
    }
    private func configConstraints() {
        contentView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50).isActive = true
        containerStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        
        [userTextField, passwordTextField, loginButton, forgotPasswordButton, registerButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    private func configTargets() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
    private func makeTextField(placeholder: String, isSecure: Bool ) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .gray.withAlphaComponent(0.1)
        textField.placeholder = placeholder
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = isSecure
        return textField
    }
    private func makeTitleButton(
        title: String
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return button
    }
    
    @objc func didTapLoginButton() {
        guard viewModel.checkName(name: userTextField.text ?? "", password: passwordTextField.text ?? "") == true else {
            presentAlert(message: "Incorrect username or password.", title: "Error")
            return
        }
        coordinator.didTapLoginButton()
    }
    
    @objc func didTapForgotButton() {
        print("sin crear")
    }
    
    @objc func didTapRegisterButton() {
        coordinator.didTapRegisterButton()
    }
}
extension HomeMenuViewController: ViewScrollable {}
extension HomeMenuViewController: MessageDisplayable { }
extension HomeMenuViewController: KeyboardDisplayable {}
