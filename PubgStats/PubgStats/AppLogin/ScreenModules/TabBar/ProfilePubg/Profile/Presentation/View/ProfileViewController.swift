//
//  ProfilePubgViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {
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
    private lazy var profileImageView = makeImageView(name: "default", height: 300, width: 300)
    private lazy var containerStackView = makeStack(space: 20)
    private lazy var personalDataButton: UIButton = makeButtonBlue(title: "Personal Data")
    private lazy var settingButton: UIButton = makeButtonBlue(title: "Setting")
    private lazy var linkPubgAccountButton: UIButton = makeButtonBlue(title: "Link Pubg Account")
    private lazy var statsAccountButton: UIButton = makeButtonBlue(title: "Stats Account: nameAccount")
    
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private let dependencies: ProfileDependency
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), dependencies: ProfileDependency) {
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
    private func configUI() {
        view.backgroundColor = .systemBackground
        let barLeftButton = UIBarButtonItem(customView: logOutButton)
        navigationItem.leftBarButtonItem = barLeftButton
        chooseButton(buttonLink: linkPubgAccountButton, buttonStat: statsAccountButton)
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        navigationItem.title = "Bienvenido \(sessionUser.name)!"
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .fail(_):
                self?.presentAlert(message: "El nombre de usuario no existe", title: "Error")
            case .success(let model):
                let account = model.id
                let name = model.name
                print("Name: \(name ?? "no existe name") y account \(account ?? "no existe account")")
                //TODO: guardar aqui en core data
            case .loading:
                print("esperando")
            }
        }.store(in: &cancellable)
    }
    func chooseButton(buttonLink: UIButton, buttonStat: UIButton ) {
        if buttonLink.superview == nil {
            buttonLink.isHidden = false
            buttonStat.isHidden = true
        } else {
            buttonLink.isHidden = true
            buttonStat.isHidden = false
        }
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
   
    private func configTargets() {
        personalDataButton.addTarget(self, action: #selector(didTapPersonalDataButton), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        linkPubgAccountButton.addTarget(self, action: #selector(didTapLinkPubgAccountButton), for: .touchUpInside)
        statsAccountButton.addTarget(self, action: #selector(didTapStatsgAccountButton), for: .touchUpInside)
    }
    private func logOut() {
        viewModel.logOut()
    }
    @objc func didTapPersonalDataButton() {
        viewModel.didTapPersonalDataButton()
    }
    @objc func didTapSettingButton() {
        viewModel.didTapSettingButton()
    }
    @objc func didTapLinkPubgAccountButton() {
        let alert = UIAlertController(title: "Player", message: "", preferredStyle: .alert)
        alert.addTextField{ (namePubg) in
            namePubg.placeholder = "Name PLayer"
        }
        let actionAccept = UIAlertAction(title: "Accept", style: .default){ [weak self]_ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else {
                self?.presentAlert(message: "There are no users with an empty name", title: "Error")
                return}
            self?.viewModel.dataGeneral(name: name)
            
            //TODO: Cambiar el boton
            self?.viewModel.didTapLinkPubgAccountButton()
        }
        let actionCancel = UIAlertAction(title: "cancelar", style: .destructive)
        alert.addAction(actionAccept)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    @objc func didTapStatsgAccountButton() {
        viewModel.didTapStatsgAccountButton()
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
