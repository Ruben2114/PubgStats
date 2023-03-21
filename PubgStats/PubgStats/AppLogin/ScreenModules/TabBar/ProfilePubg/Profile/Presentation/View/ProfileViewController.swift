//
//  ProfilePubgViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Combine

protocol ProfileViewControllerCoordinator: AnyObject {
    func didTapPersonalDataButton()
    func didTapSettingButton()
    func didTapLinkPubgAccountButton()
    func didTapStatsgAccountButton()
}

final class ProfileViewController: UIViewController {
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private weak var coordinator: ProfileViewControllerCoordinator?
    
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), viewModel: ProfileViewModel, coordinator: ProfileViewControllerCoordinator) {
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
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
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
 
    private lazy var personalDataButton: UIButton = makeTitleButton(title: "Personal Data")
    private lazy var settingButton: UIButton = makeTitleButton(title: "Setting")
    private lazy var linkPubgAccountButton: UIButton = makeTitleButton(title: "Link Pubg Account")
    private lazy var statsAccountButton: UIButton = makeTitleButton(title: "Stats Account: nameAccount")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScroll()
        viewModel.chooseButton(buttonLink: linkPubgAccountButton, buttonStat: statsAccountButton)
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
        //TODO: DOS BOTONES OCULTOS Y EL VIEWMODEL ELIGE CUAL MOSTRAR Y QUE MOSTRAR (LA FOTO, EL NOMBRE...)
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
        
        [personalDataButton, settingButton, linkPubgAccountButton, statsAccountButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    private func makeTitleButton(
        title: String
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    
    private func configTargets() {
        personalDataButton.addTarget(self, action: #selector(didTapPersonalDataButton), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        linkPubgAccountButton.addTarget(self, action: #selector(didTapLinkPubgAccountButton), for: .touchUpInside)
        statsAccountButton.addTarget(self, action: #selector(didTapStatsgAccountButton), for: .touchUpInside)
    }
    private func logOut() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewAppCoordinator()
        print("volver  realizar el login")
    }
  
    @objc func didTapPersonalDataButton() {
        coordinator?.didTapPersonalDataButton()
    }
    @objc func didTapSettingButton() {
        coordinator?.didTapSettingButton()
    }
    @objc func didTapLinkPubgAccountButton() {
        coordinator?.didTapLinkPubgAccountButton()
    }
    @objc func didTapStatsgAccountButton() {
        coordinator?.didTapStatsgAccountButton()
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
}
extension ProfileViewController: MessageDisplayable { }
extension ProfileViewController: ViewScrollable {}
extension ProfileViewController: KeyboardDisplayable {}
