//
//  LoginViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private lazy var containerStackView = makeStack(space: 20)
    private lazy var userTextField = makeTextFieldLogin(placeholder: "userTextField".localize(), isSecure: false)
    private lazy var passwordTextField = makeTextFieldLogin(placeholder: "passwordTextField".localize(), isSecure: true)
    private lazy var loginButton: UIButton = makeButtonBlue(title: "titleLoginButton".localize())
    private lazy var registerButton: UIButton = makeButtonCorner(
        title: "titleRegister".localize())
    private lazy var forgotPasswordButton: UIButton = makeButtonClear(
        title: "titleForgot".localize())
    private let imageView = UIImageView(image: UIImage(named: "backgroundPubg"))
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: LoginViewModel
    private var dependencies: LoginDependency
    init(dependencies: LoginDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bind()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        configScroll()
        configKeyboardSubscription(mainScrollView: mainScrollView)
        hideKeyboard()
        configConstraints()
        configGradientForTitle()
        configTargets()
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state{
            case .success:
                self?.hideSpinner()
            case .loading:
                self?.showSpinner()
            case .fail(error: let error):
                self?.hideSpinner()
                self?.presentAlert(message: error, title: "Error")
            }
        }.store(in: &cancellable)
    }
    private func configConstraints() {
        view.insertSubview(imageView, at: 0)
        imageView.frame = view.bounds
        
        contentView.addSubview(containerStackView)
        containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor).isActive = true
        
        [userTextField, passwordTextField, loginButton, registerButton ,forgotPasswordButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    private func configGradientForTitle() {
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = view.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.darkGray.cgColor]
        gradientMaskLayer.locations = [0.0, 1.0]
        gradientMaskLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientMaskLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        view.layer.insertSublayer(gradientMaskLayer, at: 1)
    }
    private func configTargets() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    @objc private func didTapLoginButton() {
        guard let password = passwordTextField.text?.hashString(), let user = userTextField.text else{return}
        viewModel.check(sessionUser: dependencies.external.resolve(),name: user, password: password)
    }
    @objc private func didTapForgotButton() {
        viewModel.didTapForgotButton()
    }
    
    @objc private func didTapRegisterButton() {
        viewModel.didTapRegisterButton()
    }
}
extension LoginViewController: SpinnerDisplayable { }
extension LoginViewController: ViewScrollable {}
extension LoginViewController: MessageDisplayable { }
extension LoginViewController: KeyboardDisplayable {}

