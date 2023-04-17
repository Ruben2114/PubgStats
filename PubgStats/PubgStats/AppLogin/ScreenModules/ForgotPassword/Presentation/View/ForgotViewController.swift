//
//  ForgotViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//
import UIKit
import Combine

final class ForgotViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    private lazy var containerStackView = makeStack(space: 30)
    private lazy var titleLabel = makeLabel(title: "Recuperar contraseña", color: .white, font: 25, style: .title2)
    private lazy var alertLabel = makeLabel(title: "Tu contraseña nueva será: 0000\n Por favor, cambiala en cuanto accedas a tu perfil.", color: .white, font: 15, style: .title2)
    private lazy var userTextField = makeTextFieldBlack(placeholder: "Nombre Usuario", isSecure: false)
    private lazy var emailTextField = makeTextFieldBlack(placeholder: "Correo: pubg@pubgstats.com", isSecure: false)
    private lazy var acceptButton = makeButtonBlue(title: "Guardar")
    
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let viewModel: ForgotViewModel
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), dependencies: ForgotDependency) {
        self.mainScrollView = mainScrollView
        self.contentView = contentView
        self.cancellable = cancellable
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
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.backButton()
    }
    
    private func configUI() {
        view.backgroundColor = .black
        sheetPresentationController.delegate = self
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [.medium()]
    }
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state{
            case .success:
                self?.hideSpinner()
                self?.dismiss(animated: true)
            case .loading:
                self?.showSpinner()
            case .fail(error: let error):
                self?.hideSpinner()
                self?.presentAlert(message: "Error: \(error)", title: "Error")
            }
        }.store(in: &cancellable)
    }
    private func configConstraints() {
        contentView.addSubview(containerStackView)
        containerStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        
        [titleLabel, alertLabel, userTextField, emailTextField, acceptButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    private func configTargets() {
        acceptButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    @objc func didTapSaveButton() {
        guard let nameText = userTextField.text, let emailText = emailTextField.text?.lowercased() else {return}
        viewModel.checkAndChangePassword(name: nameText, email: emailText)
    }
}
extension ForgotViewController: MessageDisplayable { }
extension ForgotViewController: ViewScrollable {}
extension ForgotViewController: KeyboardDisplayable {}
extension ForgotViewController: SpinnerDisplayable {}
