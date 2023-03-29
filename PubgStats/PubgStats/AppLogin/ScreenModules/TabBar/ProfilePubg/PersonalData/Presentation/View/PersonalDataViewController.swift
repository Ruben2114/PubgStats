//
//  PersonalDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import Combine
//TODO: crear array con title y image para el ui collect
struct Edit {
    let title: String
    let image: String
}


final class PersonalDataViewController: UIViewController {
    //si borra el player actualizar lo del boton
    //tres botones con el texto y un emoticono de editar todo en un stack horizontal y encima la foto, asi puede ver como se cambian sus datos + abajo sus datos principales del link: nombre, level... y encima el boton de eliminar, el stack el mismo que en su pantalla
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let layoutWidth = (ViewValues.widthScreen - ViewValues.doublePadding) / ViewValues.multiplierTwo
        let layoutHeigth = (ViewValues.widthScreen - ViewValues.doublePadding) / ViewValues.multiplierTwo
        layout.itemSize = CGSize(width: layoutWidth, height: layoutHeigth)
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        layout.sectionInset = UIEdgeInsets(top: .zero, left: ViewValues.normalPadding, bottom: .zero, right: ViewValues.normalPadding)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var profileImageView = makeImageView(name: "default", height: 300, width: 300)
    
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let dependencies: PersonalDataDependency
    private let viewModel: PersonalDataViewModel
    let sessionUser: ProfileEntity
    let dataEdit = [Edit(title: "Contraseña", image: "star"),
                      Edit(title: "Fotografía", image: "star"),
                      Edit(title: "Borrar cuenta Pubg", image: "star")]
    
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
        configKeyboardSubscription(mainScrollView: mainScrollView)
        bind()
        hideKeyboard()
    }
    private func bind(){
        
        /*
         otra tabla con estos datos de cuenta pubg
        guard sessionUser.survival == nil else {return}
        
        nameAccountLabel.text = sessionUser.player
        levelAccountLabel.text = "\(sessionUser.survival?.first?.data.attributes.level)"
        xpAccountLabel.text = "\(sessionUser.survival?.first?.data.attributes.xp)"
         */
            
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Personal Data"
        backButton(action: #selector(backButtonAction))
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    private func configConstraints(){
        contentView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50).isActive = true
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
    }
    
    //TODO: acciones de cada tabla ponerlo con if
    @objc func didTapPasswordButton() {
        let alert = UIAlertController(title: "Cambio de contraseña", message: "¿Estás seguro de que quieres cambiar la contraseña?", preferredStyle: .alert)
        alert.addTextField{ (password) in
            password.placeholder = "Nueva contraseña"
        }
        alert.addTextField { (repeatPassword)in
            repeatPassword.placeholder = "Repite la nueva contraseña"
        }
        
        let actionAccept = UIAlertAction(title: "Accept", style: .default){ [weak self]_ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else {
                self?.presentAlert(message: "La contraseña tiene que tener como minimo un caracter", title: "Error")
                return}
            guard alert.textFields?.first?.text == alert.textFields?.last?.text else {
                self?.presentAlert(message: "Contraseñas diferentes", title: "Error")
                return}
            self?.viewModel.goPasswordData()
        }
        let actionCancel = UIAlertAction(title: "cancelar", style: .destructive)
        alert.addAction(actionAccept)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    @objc func didTapImageButton() {
        //TODO: abrir la galeria de fotos y coger una foto
        viewModel.goImageData()
    }
    @objc func didTapPubgAccountButton() {
        let alert = UIAlertController(title: "Borrar cuenta de Pugb", message: "¿Estás seguro de que quieres eliminar la cuenta asociada de Pugb a esta app?", preferredStyle: .alert)
        let actionAccept = UIAlertAction(title: "Accept", style: .default){ [weak self]_ in
            self?.viewModel.goPubgAccount()
        }
        let actionCancel = UIAlertAction(title: "cancelar", style: .destructive)
        alert.addAction(actionAccept)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    // hasta aqui las acciones
    
    
    
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}
extension PersonalDataViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataEdit.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemCyan
        cell.layer.cornerRadius = 15
        let model = dataEdit[indexPath.row]
        var contenido = UIListContentConfiguration.cell()
        contenido.text = model.title
        contenido.image = UIImage(systemName: model.title)
        contenido.textProperties.alignment = .center
        cell.contentConfiguration = contenido
        return cell
    }
}


extension PersonalDataViewController: MessageDisplayable { }
extension PersonalDataViewController: ViewScrollable {}
extension PersonalDataViewController: KeyboardDisplayable {}
extension PersonalDataViewController: SpinnerDisplayable{ }

