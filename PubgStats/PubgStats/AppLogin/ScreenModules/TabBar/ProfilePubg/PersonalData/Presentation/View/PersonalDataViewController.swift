//
//  PersonalDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import Combine


final class PersonalDataViewController: UIViewController {
    //si borra el player actualizar lo del boton
    //tres botones con el texto y un emoticono de editar todo en un stack horizontal y encima la foto, asi puede ver como se cambian sus datos + abajo sus datos principales del link: nombre, level... y encima el boton de eliminar, el stack el mismo que en su pantalla
   
    private lazy var profileImageView = makeImageView(name: "default", height: 300, width: 300)
    
    //poner private?
    var segmentedControl: UISegmentedControl!
    var viewOption1: UIView!
    var viewOption2: UIView!
    var viewOption3: UIView!
    
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
    }
    func createSegmentedController() {
        
         viewOption1 = UIView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100))
         viewOption1.backgroundColor = .red
         
         viewOption2 = UIView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100))
         viewOption2.backgroundColor = .green
         
         viewOption3 = UIView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100))
         viewOption3.backgroundColor = .blue
         
         // Agrega las vistas creadas como subvistas a la vista principal
         contentView.addSubview(viewOption1)
         contentView.addSubview(viewOption2)
         contentView.addSubview(viewOption3)
         
         // Oculta todas las vistas excepto la vista inicial
         viewOption2.isHidden = true
         viewOption3.isHidden = true
         
         // Crea el controlador segmentado y agrega las opciones
         segmentedControl = UISegmentedControl(items: ["Red", "Green", "Blue"])
         segmentedControl.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 50)
         segmentedControl.selectedSegmentIndex = 0
         
         // Configura la acción del controlador segmentado para mostrar la vista correspondiente y ocultar las otras vistas
         segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

         // Agrega el controlador segmentado a la vista principal
         contentView.addSubview(segmentedControl)
    }
    
    // Acción del controlador segmentado
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
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
    
    private func configConstraints(){
        /*
         contentView.addSubview(profileImageView)
         profileImageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40).isActive = true
         profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
         
         contentView.addSubview(collectionView)
         collectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50).isActive = true
         collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
         collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
         */
        
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


extension PersonalDataViewController: MessageDisplayable { }
extension PersonalDataViewController: ViewScrollable {}
extension PersonalDataViewController: KeyboardDisplayable {}
extension PersonalDataViewController: SpinnerDisplayable{ }

