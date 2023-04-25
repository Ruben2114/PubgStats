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
    private lazy var nameLabel = makeLabelProfile(title: sessionUser.name, color: .black, font: 20, style: .title2, isBold: true)
    private lazy var emailLabel = makeLabelProfile(title: sessionUser.email, color: .black, font: 20, style: .title2, isBold: false)
    private lazy var tableView = makeTableViewGroup()
    private var refreshCount = 0
    
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private let dependencies: ProfileDependency
    private let sessionUser: ProfileEntity
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
        navigationItem.title = "profileViewControllerNavigationItem".localize()
        backButton(action: #selector(backButtonAction))
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .fail(let error):
                self?.presentAlert(message: error, title: "Error")
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
        let alert = UIAlertController(title: "alertTitle".localize(), message: "profileBackButtonAction".localize(), preferredStyle: .alert)
        let actionAccept = UIAlertAction(title: "actionAccept".localize(), style: .default){ [weak self]_ in
            self?.viewModel.backButton()
        }
        let actionCancel = UIAlertAction(title: "actionCancel".localize(), style: .destructive)
        alert.addAction(actionAccept)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
}

extension ProfileViewController: MessageDisplayable { }
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let profileFieldInfo = viewModel.items[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont.systemFont(ofSize: 20)
        listContent.text = profileFieldInfo.title()
        listContent.image =  UIImage(systemName: profileFieldInfo.icon())
        cell.contentConfiguration = listContent
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let profileFieldInfo = viewModel.items[indexPath.section][indexPath.row]
        if sessionUser.account == nil {
            cell.isHidden = profileFieldInfo == .stats || profileFieldInfo == .delete
        } else {
            cell.isHidden = profileFieldInfo == .login
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileFieldInfo = viewModel.items[indexPath.section][indexPath.row]
        switch profileFieldInfo {
        case .name:
            presentAlertTextField(title: "profileFieldInfoNameTitle".localize(),
                                  message: "profileFieldInfoNameMessage".localize(),
                                  textFields: [(title: "profileFieldInfoNameTextFields".localize(), placeholder: "profileFieldInfoNameTextFields".localize())],
                                  completed: { text in
                self.nameCell(text: text)
            }, isSecure: false)
        case .email:
            presentAlertTextField(title: "profileFieldInfoEmailTitle".localize(),
                                  message: "profileFieldInfoEmailMessage".localize(),
                                  textFields: [(title: "profileFieldInfoEmailTextFields".localize(), placeholder: "profileFieldInfoEmailTextFields".localize())],
                                  completed: { text in
                self.emailCell(text: text)
            }, isSecure: false)
        case .password:
            presentAlertTextField(title: "profileFieldInfoPasswordTitle".localize(),
                                  message: "profileFieldInfoPasswordMessage".localize(),
                                  textFields: [(title: "profileFieldInfoPasswordTextFields".localize(),
                                                placeholder: "profileFieldInfoPasswordTextFields".localize()),
                                               (title: "profileFieldInfoPasswordTextFieldsSecond".localize(),
                                                placeholder: "profileFieldInfoPasswordTextFieldsSecond".localize())],
                                  completed: { text in
                self.passwordCell(text: text)
            }, isSecure: true)
        case .image:
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        case .login:
            presentAlertTextField(title: "profileFieldInfoLoginTitle".localize(),
                                  message: "",
                                  textFields: [(title: "profileFieldInfoLoginTextFields".localize(), placeholder: "profileFieldInfoLoginTextFields".localize())],
                                  completed: { text in
                self.loginCell(text: text)
            }, isSecure: false)
        case .stats:
            viewModel.didTapStatsgAccountButton()
        case .delete:
            let alert = UIAlertController(title: "alertTitle".localize(),
                                          message: "profileFieldInfoDeleteMessage".localize(),
                                          preferredStyle: .alert)
            let actionAccept = UIAlertAction(title: "actionAccept".localize(), style: .default){ [weak self]_ in
                self?.viewModel.deletePubgAccount()
                self?.tableView.reloadData()
            }
            let actionCancel = UIAlertAction(title: "actionCancel".localize(), style: .destructive)
            alert.addAction(actionCancel)
            alert.addAction(actionAccept)
            present(alert, animated: true)
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

//MARK: tableView selection actions
private extension ProfileViewController {
    func nameCell (text: [String]){
        guard let nameText = text.first else {return}
        guard viewModel.checkName(name: nameText) != true, !nameText.isEmpty else {
            if nameText.isEmpty {
                presentAlert(message: "nameTextEmpty".localize(), title: "Error")
            }else {
                presentAlert(message: "nameTextExist".localize(), title: "Error")
            }
            return
        }
        viewModel.changeValue(sessionUser: self.dependencies.external.resolve(),nameText, type: "name")
        presentAlertTimer(message: "profileNameCellMessage".localize(), title: "alertTitle".localize(), timer: 1.0)
        viewChange()
    }
    func emailCell(text: [String]){
        guard let newEmail = text.first, checkValidEmail(email: newEmail) == true else {
            presentAlert(message: "emailTextInvalid".localize(), title: "Error")
            return
        }
        guard viewModel.checkEmail(email: newEmail) != true else {
            presentAlert(message: "emailTextExist".localize(), title: "Error")
            return
        }
        viewModel.changeValue(sessionUser: self.dependencies.external.resolve(),newEmail, type: "email")
        viewChange()
    }
    func passwordCell(text: [String]){
        guard let newPassword = text.first, !newPassword.isEmpty else {
            presentAlert(message: "passwordTextEmpty".localize(), title: "Error")
            return}
        guard newPassword == text.last else {
            presentAlert(message: "profilePasswordCellDifferent".localize(), title: "Error")
            return}
        guard let newPasswordHash = newPassword.hashString() else {return}
        viewModel.changeValue(sessionUser: self.dependencies.external.resolve(),newPasswordHash, type: "password")
        viewChange()
    }
    func loginCell(text: [String]){
        guard let nameText = text.first, !nameText.isEmpty else {
            presentAlert(message: "profileLoginCellInvalid".localize(), title: "Error")
            return}
        viewModel.dataGeneral(name: nameText)
    }
}
