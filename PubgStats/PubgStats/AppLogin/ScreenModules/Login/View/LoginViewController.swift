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
    private lazy var segmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Steam", "Survival"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.layer.cornerRadius = 15
        segmented.layer.borderColor = UIColor.orange.cgColor
        segmented.layer.borderWidth = 1
        segmented.backgroundColor = .systemGray2
        segmented.selectedSegmentTintColor = .black
        segmented.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()
    private lazy var loginButton: UIButton = makeButtonBlue(title: "titleLoginButton".localize())
    private lazy var imageView: UIImageView = {
        return UIImageView(image: UIImage(named: "backgroundPubg"))
    }()
    private var platform: String = "steam"
    
    private let viewModel: LoginViewModel
    private var dependencies: LoginDependency
    private var cancellable = Set<AnyCancellable>()
    private var bottomConstraint: NSLayoutConstraint?
    
    init(dependencies: LoginDependency) {
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .sendInfoProfile(let data):
                self?.hideSpinner()
                self?.viewModel.goToProfile(data: data)
            case .sendInfoProfileError:
                self?.hideSpinner()
                self?.view.endEditing(true)
                self?.presentAlert(message: "El player no existe", title: "Error")
            case .showLoading:
                //TODO: cambiar el spinner por un lottie json
                self?.showSpinner()
            }
        }.store(in: &cancellable)
    }
    
    func configConstraints() {
        view.insertSubview(imageView, at: 0)
        imageView.frame = view.bounds
        
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
            presentAlert(message: "profileLoginCellInvalid".localize(), title: "Error")
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

extension LoginViewController: SpinnerDisplayable { }
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


