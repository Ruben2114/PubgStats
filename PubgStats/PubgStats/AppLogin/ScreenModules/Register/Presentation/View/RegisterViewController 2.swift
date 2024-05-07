//
//  RegisterViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import UIKit
import Combine

protocol RegisterViewControllerCoordinator: AnyObject {
    func didTapAcceptButton()
}

final class RegisterViewController: UIViewController {
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: RegisterViewModel
    private weak var coordinator: RegisterViewControllerCoordinator?
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register on AppPubgStats"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var userTextField = makeTextField(placeholder: "User Name", isSecure: false)
    private lazy var passwordTextField = makeTextField(placeholder: "Password", isSecure: true)
    private let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()

    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), coordinator: RegisterViewControllerCoordinator, viewModel: RegisterViewModel) {
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
        bind()
        hideKeyboard()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
    }
    private func configConstraints() {
        contentView.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200).isActive = true
        containerStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        [titleLabel,userTextField, passwordTextField, acceptButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
        
    private func configTargets() {
        acceptButton.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
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
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state{
            case .success:
                self?.hideSpinner()
                self?.coordinator?.didTapAcceptButton()
            case .loading:
                self?.showSpinner()
            case .fail(error: let error):
                self?.presentAlert(message: "Error: \(error)", title: "Error")
            }
        }.store(in: &cancellable)
    }
    @objc func didTapAcceptButton() {
        let nameText = userTextField.text
        let passwordText = passwordTextField.text?.hashString()
        guard !nameText!.isEmpty, !passwordText!.isEmpty else {
            presentAlert(message: "Please, fill in all fields", title: "Error")
            return
        }
        guard viewModel.checkName(name: nameText ?? "") != true else {
            presentAlert(message: "User already exists", title: "Error")
            return
        }
        viewModel.saveUser(name: nameText ?? "", password: passwordText ?? "")
    }
}
extension RegisterViewController: MessageDisplayable { }
extension RegisterViewController: ViewScrollable {}
extension RegisterViewController: KeyboardDisplayable {}
extension RegisterViewController: SpinnerDisplayable {}



