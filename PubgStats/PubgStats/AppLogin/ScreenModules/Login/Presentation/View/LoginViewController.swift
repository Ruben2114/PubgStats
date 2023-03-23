//
//  LoginViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private lazy var profileImageView = makeImageView(name: "pubgHome", height: 200, width: 300)
    private lazy var containerStackView = makeStack(space: 20)
    private lazy var userTextField = makeTextField(placeholder: "User Name", isSecure: false)
    private lazy var passwordTextField = makeTextField(placeholder: "Password", isSecure: true)
    private lazy var loginButton: UIButton = makeButtonBlue(title: "Log In")
    private lazy var forgotPasswordButton: UIButton = makeButtonClear(
        title: "forgot your password?")
    private lazy var registerButton: UIButton = makeButtonClear(
        title: "Sign Up")

    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: LoginViewModel
    
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), dependencies: LoginDependency) {
        self.mainScrollView = mainScrollView
        self.contentView = contentView
        self.cancellable = cancellable
        self.viewModel = dependencies.resolve()
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
        bind()
        hideKeyboard()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
    }
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state{
            case .success:
                //enviar currentUser creando singleton
                print("enviar el current User")
                self?.viewModel.didTapLoginButton()
            case .loading:
                break
            case .fail(error: let error):
                self?.presentAlert(message: error, title: "Error")
            }
        }.store(in: &cancellable)
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
    
    @objc func didTapLoginButton() {
        let password = passwordTextField.text?.hashString()
        viewModel.checkName(name: userTextField.text ?? "", password: password ?? "")
    }
    
    @objc func didTapForgotButton() {
        viewModel.didTapForgotButton()
    }
    
    @objc func didTapRegisterButton() {
        viewModel.didTapRegisterButton()
    }
}
extension LoginViewController: ViewScrollable {}
extension LoginViewController: MessageDisplayable { }
extension LoginViewController: KeyboardDisplayable {}
