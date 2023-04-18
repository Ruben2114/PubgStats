//
//  LoginViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import UIKit
import Combine
import AVFoundation

class LoginViewController: UIViewController {
    private var videoLogin: AVPlayer?
    private lazy var containerStackView = makeStack(space: 20)
    private lazy var userTextField = makeTextFieldLogin(placeholder: "Usuario", isSecure: false)
    private lazy var passwordTextField = makeTextFieldLogin(placeholder: "Contraseña", isSecure: true)
    private lazy var loginButton: UIButton = makeButtonBlue(title: "Iniciar Sesión")
    private lazy var registerButton: UIButton = makeButtonCorner(
        title: "Crear Cuenta")
    private lazy var forgotPasswordButton: UIButton = makeButtonClear(
        title: "Recuperar Contraseña")
    
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: LoginViewModel
    private var dependencies: LoginDependency
    
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), dependencies: LoginDependency) {
        self.mainScrollView = mainScrollView
        self.contentView = contentView
        self.cancellable = cancellable
        self.dependencies = dependencies
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
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let filePath = Bundle.main.path(forResource: "videoLoginPubg", ofType: "mp4") else { return }
        let fileUrl = URL(fileURLWithPath: filePath)
        videoLogin = AVPlayer(url: fileUrl)
        let videoLayer = AVPlayerLayer(player: videoLogin)
        videoLayer.videoGravity = .resize
        videoLayer.frame = view.bounds
        videoLayer.zPosition = -1
        view.layer.addSublayer(videoLayer)
        videoLogin?.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoLogin?.currentItem, queue: .main) { [weak self] _ in
            self?.videoLogin?.seek(to: .zero)
            self?.videoLogin?.play()
        }
        configGradientForTitle()
    }
    private func configGradientForTitle() {
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = view.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.darkGray.cgColor]
        gradientMaskLayer.locations = [0.0, 1.0]
        gradientMaskLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientMaskLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        view.layer.addSublayer(gradientMaskLayer)
        gradientMaskLayer.zPosition = -1
    }
  
    private func configUI() {
        view.backgroundColor = .systemBackground
    }
    func bind() {
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
        contentView.addSubview(containerStackView)
        containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewValues.doublePadding).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewValues.doublePadding).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewValues.doublePadding).isActive = true
        
        [userTextField, passwordTextField, loginButton, registerButton ,forgotPasswordButton].forEach {
                containerStackView.addArrangedSubview($0)
        }
    }
    private func configTargets() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
    @objc func didTapLoginButton() {
        guard let password = passwordTextField.text?.hashString(), let user = userTextField.text else{return}
        viewModel.check(sessionUser: dependencies.external.resolve(),name: user, password: password)
    }
    @objc func didTapForgotButton() {
        viewModel.didTapForgotButton()
    }
    
    @objc func didTapRegisterButton() {
        viewModel.didTapRegisterButton()
    }
}
extension LoginViewController: SpinnerDisplayable { }
extension LoginViewController: ViewScrollable {}
extension LoginViewController: MessageDisplayable { }
extension LoginViewController: KeyboardDisplayable {}
