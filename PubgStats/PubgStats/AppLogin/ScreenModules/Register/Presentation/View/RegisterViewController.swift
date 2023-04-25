//
//  RegisterViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import UIKit
import Combine

final class RegisterViewController: UIViewController,UISheetPresentationControllerDelegate {
    
    private lazy var containerStackView = makeStack(space: 20)
    private lazy var titleLabel = makeLabel(title: "titleRegister".localize(), color: .white, font: 25, style: .title2)
    private lazy var userTextField = makeTextFieldBlack(placeholder: "userTextField".localize(), isSecure: false)
    private lazy var emailTextField = makeTextFieldBlack(placeholder: "emailTextField".localize(), isSecure: false)
    private lazy var passwordTextField = makeTextFieldBlack(placeholder: "passwordTextField".localize(), isSecure: true)
    private lazy var acceptButton = makeButtonBlue(title: "titleAcceptButton".localize())
    
    var cancellable = Set<AnyCancellable>()
    private let viewModel: RegisterViewModel
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    init(dependencies: RegisterDependency) {
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configConstraints()
        configTargets()
        configKeyboardSubscription(mainScrollView: UIScrollView())
        bind()
        hideKeyboard()
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.backButton()
    }
    
    private func configUI() {
        view.backgroundColor = .black
        sheetPresentationController.delegate = self
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [.medium()]
    }
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state{
            case .success:
                self?.hideSpinner()
                self?.dismiss(animated: true)
            case .loading:
                self?.showSpinner()
            case .fail(error: let error):
                self?.hideSpinner()
                self?.presentAlert(message: "Error: \(error)", title: "Error")
            }
        }.store(in: &cancellable)
    }
    private func configConstraints() {
        view.addSubview(containerStackView)
        containerStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        containerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        
        [titleLabel,userTextField, emailTextField ,passwordTextField, acceptButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    private func configTargets() {
        acceptButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    @objc func didTapSaveButton() {
        guard let nameText = userTextField.text, let emailText = emailTextField.text else {return}
        guard viewModel.checkName(name: nameText) != true, !nameText.isEmpty else {
            if nameText.isEmpty {
                presentAlert(message: "nameTextEmpty".localize(), title: "Error")
            }else {
                presentAlert(message: "nameTextExist".localize(), title: "Error")
            }
            return
        }
        guard checkValidEmail(email: emailText) == true else {
            presentAlert(message: "emailTextInvalid".localize(), title: "Error")
            return
        }
        guard viewModel.checkEmail(email: emailText) != true else {
            presentAlert(message: "emailTextExist".localize(), title: "Error")
            return
        }
        guard let passwordText = passwordTextField.text?.hashString() else {return}
        guard !passwordText.isEmpty else {
            presentAlert(message: "passwordTextEmpty".localize(), title: "Error")
            return}
        viewModel.saveUser(name: nameText, password: passwordText, email: emailText)
    }
}
extension RegisterViewController: MessageDisplayable { }
extension RegisterViewController: KeyboardDisplayable {}
extension RegisterViewController: SpinnerDisplayable {}


