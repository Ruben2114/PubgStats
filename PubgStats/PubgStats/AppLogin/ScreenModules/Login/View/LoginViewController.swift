//
//  LoginViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private lazy var containerStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    private lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "userTextField".localize()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.font = ConstantFormat.mediumFontBold
        textField.layer.cornerRadius = 20
        textField.isSecureTextEntry = false
        return textField
    }()
    private lazy var segmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Steam", "Xbox"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.layer.cornerRadius = 15
        segmented.layer.borderColor = ConstantFormat.colorDefault.cgColor
        segmented.layer.borderWidth = 1
        segmented.backgroundColor = .systemGray2
        segmented.selectedSegmentTintColor = .black
        segmented.setTitleTextAttributes([.foregroundColor : UIColor.white,
                                          .font : ConstantFormat.smallFontBold ?? .systemFont(ofSize: 16)], for: .normal)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("titleLoginButton".localize(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = ConstantFormat.mediumFontBold
        button.layer.cornerRadius = 20
        button.backgroundColor = ConstantFormat.colorDefault
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private var platform: String = "steam"
    private let viewModel: LoginViewModel
    private var dependencies: LoginDependencies
    private var cancellable = Set<AnyCancellable>()
    private var bottomConstraint: NSLayoutConstraint?
    
    init(dependencies: LoginDependencies) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        bind()
        viewModel.viewDidLoad()
    }
}

private extension LoginViewController {
    func setAppearance() {
        configView()
        addObserverKeyboard()
        configConstraints()
        configGradientForTitle()
        configTargets()
    }
    
    func configView() {
        configureImageBackground("backgroundPubg")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .sendInfoProfileError:
                self?.view.endEditing(true)
                self?.presentAlert(message: "profileLoginNotExitname".localize(),
                                   title: "Error", action: [.accept(nil)])
            }
        }.store(in: &cancellable)
    }
    
    func configConstraints() {
        view.addSubview(containerStackView)
        containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        bottomConstraint = containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        bottomConstraint?.isActive = true
        
        [userTextField, segmentedControl, loginButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    
    func configGradientForTitle() {
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = view.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.darkGray.cgColor]
        gradientMaskLayer.locations = [0.0, 1.0]
        gradientMaskLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientMaskLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        view.layer.insertSublayer(gradientMaskLayer, at: 1)
    }
    
    func configTargets() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(changePlatform(_:)), for: .valueChanged)
    }
    
    @objc private func dismissKeyboard(tap: UITapGestureRecognizer) {
        let location = tap.location(in: view)
        if !containerStackView.frame.contains(location) {
            view.endEditing(true)
        }
    }
    
    @objc func didTapLoginButton() {
        guard let user = userTextField.text, !user.isEmpty else{
            presentAlert(message: "profileLoginCellInvalid".localize(), title: "Error", action: [.accept(nil)])
            return}
        viewModel.checkPlayer(player: user, platform: platform)
    }
    
    @objc func changePlatform(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.platform = "steam"
        case 1:
            self.platform = "xbox"
        default:
            break
        }
    }
}

extension LoginViewController: MessageDisplayable { }
extension LoginViewController {
    func addObserverKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        bottomConstraint?.constant = -(keyboardSize.height + self.view.safeAreaInsets.bottom)
        UIView.animate(withDuration: 0.3) {  [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard(notification: NSNotification) {
        bottomConstraint?.constant = -50
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
