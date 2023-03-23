//
//  RegisterViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import UIKit
import Combine

final class RegisterViewController: UIViewController {
    
    private lazy var containerStackView = makeStack(space: 20)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register on AppPubgStats"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    private lazy var userTextField = makeTextField(placeholder: "User Name", isSecure: false)
    private lazy var passwordTextField = makeTextField(placeholder: "Password", isSecure: true)
    private lazy var acceptButton = makeButtonBlue(title: "Accept")

    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: RegisterViewModel
    
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), dependencies: RegisterDependency) {
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
                self?.hideSpinner()
                self?.viewModel.didTapAcceptButton()
            case .loading:
                self?.showSpinner()
            case .fail(error: let error):
                self?.presentAlert(message: "Error: \(error)", title: "Error")
            }
        }.store(in: &cancellable)
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
        acceptButton.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
    }
    
    @objc func didTapEmailButton() {
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



