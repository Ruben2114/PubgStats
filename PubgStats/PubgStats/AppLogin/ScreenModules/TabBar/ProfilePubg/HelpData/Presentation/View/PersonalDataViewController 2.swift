//
//  PersonalDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import Combine


final class PersonalDataViewController: UIViewController {
    private lazy var profileImageView = makeImageViewPersonal(name: "default")
    private lazy var containerStackView = makeStack(space: 30)
    private lazy var passwordTextField = makeTextFieldBorder(placeholder: "Contraseña", isSecure: true)
    private lazy var repeatPasswordTextField = makeTextFieldBorder(placeholder: "Repite la contraseña", isSecure: true)
    private lazy var acceptButton: UIButton = makeButtonBlue(title: "Guardar")
    private lazy var changePhotoButton: UIButton = makeButtonBlue(title: "Cambiar")
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    let segmentedControl: UISegmentedControl = {
       let sc = UISegmentedControl(items: ["Contraseña", "Foto perfil", "Cuenta Pubg"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private lazy var viewOption1 = makeStack(space: 20)
    private lazy var viewOption2 = makeStack(space: 20)
    private lazy var viewOption3 = tableView

    
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let dependencies: PersonalDataDependency
    private let viewModel: PersonalDataViewModel
    let sessionUser: ProfileEntity
    
    
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), dependencies: PersonalDataDependency) {
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
        configTarget()
        configKeyboardSubscription(mainScrollView: mainScrollView)
        hideKeyboard()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Personal Data"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        backButton(action: #selector(backButtonAction))
    }
    
    
    private func configConstraints(){
        contentView.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        
        contentView.addSubview(viewOption1)
        viewOption1.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40).isActive = true
        viewOption1.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        viewOption1.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        viewOption1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        [containerStackView, UIView() ,acceptButton].forEach {
            viewOption1.addArrangedSubview($0)
        }
        [passwordTextField, repeatPasswordTextField].forEach {
            containerStackView.addArrangedSubview($0)
        }
     
        
        contentView.addSubview(viewOption2)
        viewOption2.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30).isActive = true
        viewOption2.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        viewOption2.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        viewOption2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        [profileImageView, UIView(),changePhotoButton].forEach {
            viewOption2.addArrangedSubview($0)
        }
      
        
    
        
        contentView.addSubview(viewOption3)
        viewOption3.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 100).isActive = true
        viewOption3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        viewOption3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        viewOption3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        viewOption2.isHidden = true
        viewOption3.isHidden = true
    }
    
    
    private func configTarget(){
        acceptButton.addTarget(self, action: #selector(saveNewPassword), for: .touchUpInside)
        changePhotoButton.addTarget(self, action: #selector(saveNewPhoto), for: .touchUpInside)
    }
    @objc func saveNewPassword() {
        guard let password = passwordTextField.text, !password.isEmpty else {
            presentAlert(message: "La contraseña tiene que tener como minimo un caracter", title: "Error")
            return}
        guard passwordTextField.text == repeatPasswordTextField.text else {
            presentAlert(message: "Contraseñas diferentes", title: "Error")
            return}
        //viewModel.goPasswordData()
        presentAlertTimer(message: "Contraseña guardada", title: "Éxito", timer: 1.0)

    }
    @objc func saveNewPhoto() {
        
        //TODO: abrir la galeria de fotos y coger una foto
        //viewModel.goImageData()
        presentAlertTimer(message: "Foto guardada", title: "Éxito", timer: 1.0)
    }
    @objc func segmentedControlValueChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewOption1.isHidden = false
            viewOption2.isHidden = true
            viewOption3.isHidden = true
        case 1:
            viewOption1.isHidden = true
            viewOption2.isHidden = false
            viewOption3.isHidden = true
        case 2:
            viewOption1.isHidden = true
            viewOption2.isHidden = true
            viewOption3.isHidden = false
        default:
            break
        }
    }
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}


extension PersonalDataViewController: MessageDisplayable { }
extension PersonalDataViewController: ViewScrollable {}
extension PersonalDataViewController: KeyboardDisplayable {}
extension PersonalDataViewController: SpinnerDisplayable{ }
extension PersonalDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemCyan
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        listContent.text = "Leyenda"
        listContent.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16)
        listContent.secondaryText = "Nivel: 80"
        listContent.imageToTextPadding = 50
        listContent.image = UIImage(systemName: "person.circle.fill")
        cell.contentConfiguration = listContent
        return cell
    }


    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(
            style: .destructive,
            title: "Borrar",
            handler: { _, _, _  in
                print("borrar")
            }
        )
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
}
