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
    private lazy var profileImageView = makeImageViewPersonal(name: "default")
    private lazy var containerStackView = makeStack(space: 20)
    private lazy var personalDataButton: UIButton = makeButtonBlue(title: "Personal Data")
    private lazy var settingButton: UIButton = makeButtonBlue(title: "Setting")
    private lazy var linkPubgAccountButton: UIButton = makeButtonBlue(title: "Link Pubg Account")
    private lazy var statsAccountButton: UIButton = makeButtonBlue(title: "Stats Account: \(sessionUser.player ?? "")")
    
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private let dependencies: ProfileDependency
    let sessionUser: ProfileEntity
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), dependencies: ProfileDependency) {
        self.mainScrollView = mainScrollView
        self.contentView = contentView
        self.cancellable = cancellable
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        self.sessionUser = dependencies.external.resolve()
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
    //no funciona
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
    }

    private func configUI() {
        view.backgroundColor = .systemBackground
        let barLeftButton = UIBarButtonItem(customView: logOutButton)
        navigationItem.leftBarButtonItem = barLeftButton
        chooseButton()
        navigationItem.title = "Bienvenido \(sessionUser.name)!"
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .fail(_):
                self?.presentAlert(message: "El nombre de usuario no existe", title: "Error")
            case .success(let model):
                guard let account = model.id, !account.isEmpty, let player = model.name, !player.isEmpty else {return}
                self?.hideSpinner()
                self?.viewModel.saveUser(player: player, account: account)
                self?.chooseButton()
            case .loading:
                self?.showSpinner()
                
            }
        }.store(in: &cancellable)
    }
    private func chooseButton() {
        if sessionUser.account == nil {
            linkPubgAccountButton.isHidden = false
            statsAccountButton.isHidden = true
        } else {
            linkPubgAccountButton.isHidden = true
            statsAccountButton.isHidden = false
            statsAccountButton.setTitle("Stats Account: \(sessionUser.player ?? "")", for: .normal)
        }
    }
    private func configConstraints() {
      
        contentView.addSubview(containerStackView)
        containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        containerStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -50).isActive = true
        containerStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        [profileImageView,personalDataButton, settingButton, linkPubgAccountButton, statsAccountButton].forEach {
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
        let alert = UIAlertController(title: "", message: "¿Estas seguro de cerrar sesión?", preferredStyle: .alert)
        let actionAccept = UIAlertAction(title: "Accept", style: .default){ [weak self]_ in
            self?.viewModel.logOut()
        }
        let actionCancel = UIAlertAction(title: "cancelar", style: .destructive)
        alert.addAction(actionAccept)
        alert.addAction(actionCancel)
        present(alert, animated: true)
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
        }
        let actionCancel = UIAlertAction(title: "cancelar", style: .destructive)
        alert.addAction(actionAccept)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    @objc func didTapStatsgAccountButton() {
        viewModel.didTapStatsgAccountButton()
    }
}
extension ProfileViewController: MessageDisplayable { }
extension ProfileViewController: ViewScrollable {}
extension ProfileViewController: KeyboardDisplayable {}
extension ProfileViewController: SpinnerDisplayable{ }
