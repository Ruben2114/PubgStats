//
//  ProfilePubgViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {
    private lazy var profileImageView = makeImageViewPersonal(name: "default", data: sessionUser.image)
    private lazy var nameLabel = makeLabelProfile(title: "\(sessionUser.name)", color: .black, font: 20, style: .title2, isBold: true)
    private lazy var emailLabel = makeLabelProfile(title: "\(sessionUser.email)", color: .black, font: 20, style: .title2, isBold: false)
    private lazy var tableView = makeTableViewGroup()
    
    private let itemsContents = [
        ["Nombre", "Correo", "Contraseña", "Imagen"],
        ["Ayuda"],
        ["Registro cuenta Pubg", "Estadísticas cuenta", "Borrar cuenta Pubg"]
    ]
    private let imageNames = [
        ["person.circle.fill", "envelope.circle.fill", "lock.circle.fill", "photo.circle.fill"],
        ["questionmark.circle.fill"],
        ["person.crop.circle.fill.badge.plus", "folder.circle.fill", "trash.circle.fill"]
    ]
    
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
        bind()
    }
    private func viewChange() {
        nameLabel.text = sessionUser.name
        emailLabel.text = sessionUser.email
    }
    
    private func configUI() {
        view.backgroundColor = tableView.backgroundColor
        navigationItem.title = "Perfil Personal"
        backButton(action: #selector(backButtonAction))
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .fail(_):
                self?.presentAlert(message: "El nombre de usuario no existe", title: "Error")
            case .success(let model):
                guard let account = model.id, !account.isEmpty, let player = model.name, !player.isEmpty else {return}
                self?.viewModel.saveUser(player: player, account: account)
                self?.tableView.reloadData()
            case .loading:
                break
            }
        }.store(in: &cancellable)
    }
    
    private func configConstraints() {
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemsContents.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsContents[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let settingContent = itemsContents[indexPath.section][indexPath.row]
        let value = imageNames[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont.systemFont(ofSize: 20)
        listContent.text = settingContent
        listContent.image =  UIImage(systemName: value)
        cell.contentConfiguration = listContent
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if sessionUser.account == nil {
            if indexPath.section == 2 && indexPath.row == 1{
                cell.isHidden = true
            }
            if indexPath.section == 2 && indexPath.row == 2{
                cell.isHidden = true
            }
        } else {
            if indexPath.section == 2 && indexPath.row == 0 {
                cell.isHidden = true
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            presentAlertTextField(title: "Cambio de nombre",
                                  message: "¿Estás seguro de que quieres cambiar el nombre?",
                                  textFields: [(title: "Nuevo nombre", placeholder: "Nuevo nombre")],
                                  action: {},
                                  completed: { text in
                guard let nameText = text.first else {return}
                guard self.viewModel.checkName(name: nameText) != true, !nameText.isEmpty else {
                    if nameText.isEmpty {
                        self.presentAlert(message: "El nombre debe tener mínimo un caracter", title: "Error")
                    }else {
                        self.presentAlert(message: "Este nombre ya existe", title: "Error")
                    }
                    return
                }
                self.viewModel.changeValue(sessionUser: self.dependencies.external.resolve(),nameText, type: "name")
                self.presentAlertTimer(message: "Cambiado con éxito", title: "Aviso", timer: 1.0)
                self.viewChange()
            })
        case (0, 1):
            presentAlertTextField(title: "Cambio de correo",
                                  message: "¿Estás seguro de que quieres cambiar el correo?",
                                  textFields: [(title: "Nuevo correo", placeholder: "Nuevo correo")],
                                  action: {},
                                  completed: { text in
                guard let newEmail = text.first, !newEmail.isEmpty else {
                    self.presentAlert(message: "El correo tiene que tener como mínimo un caracter", title: "Error")
                    return
                }
                guard self.checkValidEmail(email: newEmail) == true else {
                    self.presentAlert(message: "El correo no es válido", title: "Error")
                    return
                }
                guard self.viewModel.checkEmail(email: newEmail) != true else {
                    self.presentAlert(message: "El correo ya existe", title: "Error")
                    return
                }
                self.viewModel.changeValue(sessionUser: self.dependencies.external.resolve(),newEmail, type: "email")
                self.viewChange()
            })
        case (0, 2):
            presentAlertTextField(title: "Cambio de contraseña",
                                  message: "¿Estás seguro de que quieres cambiar la contraseña?",
                                  textFields: [(title: "Nueva contraseña", placeholder: "Nueva contraseña"),
                                               (title: "Repite la nueva contraseña", placeholder: "Repite la nueva contraseña")],
                                  action: {},
                                  completed: { text in
                guard let newPassword = text.first, !newPassword.isEmpty else {
                    self.presentAlert(message: "La contraseña tiene que tener como mínimo un caracter", title: "Error")
                    return}
                guard newPassword == text.last else {
                    self.presentAlert(message: "Contraseñas diferentes", title: "Error")
                    return}
                guard let newPasswordHash = newPassword.hashString() else {return}
                self.viewModel.changeValue(sessionUser: self.dependencies.external.resolve(),newPasswordHash, type: "password")
                self.viewChange()
            })
        case (0, 3):
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        case (1, 0):
            viewModel.goHelp()
        case (2, 0):
            let alert = UIAlertController(title: "Jugador", message: "", preferredStyle: .alert)
            alert.addTextField{ (namePubg) in
                namePubg.placeholder = "Nombre jugador"
            }
            let actionAccept = UIAlertAction(title: "Aceptar", style: .default){ [weak self]_ in
                guard let name = alert.textFields?.first?.text, !name.isEmpty else {
                    self?.presentAlert(message: "No existen jugadores sin nombre", title: "Error")
                    return}
                self?.viewModel.dataGeneral(name: name)
            }
            let actionCancel = UIAlertAction(title: "Cancelar", style: .destructive)
            alert.addAction(actionCancel)
            alert.addAction(actionAccept)
            present(alert, animated: true)
        case (2, 1):
            viewModel.didTapStatsgAccountButton()
        case(2, 2):
            // creo que es tan facil como borrar acount para que sea nil t table.reload() ademas de borrar todos los demas registros de la base de datos
            print("borrar la cuenta, que se oculte la tabla de estadictica sy se ponga la de registro")
        default:
            break
        }
    }
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profileImageView.image = imagenSeleccionada
            guard let imageProfile = profileImageView.image else {return}
            guard let imageData = imageProfile.pngData() else {return}
            self.viewModel.changeImage(sessionUser: dependencies.external.resolve(), image: imageData)
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
