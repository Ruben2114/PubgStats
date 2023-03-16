//
//  LoginProfilePubgViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Combine

class LoginProfilePubgViewController: UIViewController {
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    lazy var logOutButton: UIButton = {
        var configuration = UIButton.Configuration.borderedTinted()
        configuration.image = UIImage(systemName: "arrowshape.turn.up.backward.circle.fill")
        configuration.baseBackgroundColor = .clear
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
            self.logOut()
        }))
        button.configuration = configuration
        button.tintColor = .black
        return button
    }()
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pubg Player"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var userTextField = makeTextField(placeholder: "Player Name")
    
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
    
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>()){
        self.mainScrollView = mainScrollView
        self.contentView = contentView
        self.cancellable = cancellable
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
        title = "Login"
        let barLeftButton = UIBarButtonItem(customView: logOutButton)
        navigationItem.leftBarButtonItem = barLeftButton
    }
    private func configConstraints() {
        contentView.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200).isActive = true
        containerStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        [titleLabel,userTextField, acceptButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    private func configTargets() {
        acceptButton.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
    }
    private func logOut() {
        //(UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController("que pongo")
        navigationController?.popViewController(animated: true)
        print("volver  realizar el login")
    }
    private func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .gray.withAlphaComponent(0.1)
        textField.placeholder = placeholder
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.layer.cornerRadius = 10
        return textField
    }
    @objc func didTapAcceptButton() {
        return
    }
}
extension LoginProfilePubgViewController: MessageDisplayable { }
extension LoginProfilePubgViewController: ViewScrollable {}
extension LoginProfilePubgViewController: KeyboardDisplayable {}
