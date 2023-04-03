//
//  ProfilePubgViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {
    
    //otra opcion
    private lazy var profileImageView = makeImageViewPersonal(name: "default")
    //todos los label
    private lazy var labelStackView = makeStack(space: 30)
    private lazy var nameLabel = makeLabelProfile(title: "Nombre: \(sessionUser.name)", color: .black, font: 20, style: .title2)
    private lazy var emailLabel = makeLabelProfile(title: "Email: \(sessionUser.email)", color: .black, font: 20, style: .title2)
    private lazy var passwordLabel = makeLabelProfile(title: "Contraseña: \(String(repeating: "*", count: 10))", color: .black, font: 20, style: .title2)
   
    
    
    
    //1 opcion
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private lazy var containerStackView = makeStack(space: 20)
    private lazy var personalDataButton: UIButton = makeButtonBlue(title: "Datos Personales")
    private lazy var settingButton: UIButton = makeButtonBlue(title: "Ajustes")
    private lazy var linkPubgAccountButton: UIButton = makeButtonBlue(title: "Link cuenta Pubg")
    private lazy var statsAccountButton: UIButton = makeButtonBlue(title: "Estadísticas cuenta: \(sessionUser.player ?? "")")
    
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private let dependencies: ProfileDependency
    let sessionUser: ProfileEntity
    init(dependencies: ProfileDependency) {
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
        configUI()
        configConstraints()
        configTargets()
        bind()
    }
   
    private func configUI() {
        view.backgroundColor = .systemBackground
        chooseButton()
        navigationItem.title = "Bienvenido \(sessionUser.name)!"
        backButton(action: #selector(backButtonAction))
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "TableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .fail(_):
                self?.presentAlert(message: "El nombre de usuario no existe", title: "Error")
                self?.hideSpinner()
            case .success(let model):
                guard let account = model.id, !account.isEmpty, let player = model.name, !player.isEmpty else {return}
                self?.hideSpinner()
                self?.viewModel.saveUser(player: player, account: account)
                //TODO: mientras hago esta llamada el boton de stactAccount isEnabled = false
                self?.viewModel.allData()
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
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.setHeightConstraint(with: 80)
        
        view.addSubview(labelStackView)
        labelStackView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 30).isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        [nameLabel, emailLabel, passwordLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        view.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 30).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

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
    @objc func backButtonAction() {
        let alert = UIAlertController(title: "", message: "¿Estas seguro de cerrar sesión?", preferredStyle: .alert)
        let actionAccept = UIAlertAction(title: "Accept", style: .default){ [weak self]_ in
            self?.viewModel.backButton()
        }
        let actionCancel = UIAlertAction(title: "cancelar", style: .destructive)
        alert.addAction(actionAccept)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
}
extension ProfileViewController: MessageDisplayable { }
extension ProfileViewController: SpinnerDisplayable{ }
extension ProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.imageUser.layer.cornerRadius = cell.imageUser.frame.width/2
        cell.imageUser.layer.borderWidth = 1.0
        cell.imageUser.layer.borderColor = UIColor.clear.cgColor
        cell.imageUser.clipsToBounds = true

        cell.nameLabel.text = "Nombre: \(sessionUser.name)"
        cell.playerLabel.text = "Player: \(sessionUser.player ?? "no existe")"
        cell.rankedLabel.text = ""
        return cell
    }
}
extension ProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
