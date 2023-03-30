//
//  ForgotViewControllerCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//
import UIKit

final class ForgotViewController: UIViewController {
    private lazy var profileImageView = makeImageView(name: "default", height: 300, width: 300)
    private lazy var containerStackView = makeStack(space: 60)
    private lazy var passwordTextField = makeTextFieldLogin(placeholder: "Contraseña", isSecure: false)
    private lazy var repeatPasswordTextField = makeTextFieldLogin(placeholder: "Repite la contraseña", isSecure: true)
    private lazy var acceptButton: UIButton = makeButtonBlue(title: "Guardar")
    var viewOption1: UIView!
    var viewOption2: UIView!
    var viewOption3: UIView!
    
    private let dependencies: ForgotDependency
    private let viewModel: ForgotViewModel
    
    let segmentedControl: UISegmentedControl = {
       let sc = UISegmentedControl(items: ["Red", "Green", "Blue"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return sc
    }()
    
    init(dependencies: ForgotDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        configViews()

    }
  
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Forgot your password"
        backButton(action: #selector(backButtonAction))
    }
    private func configViews() {
        viewOption1 = UIView(frame: CGRect(x: 0, y: 140, width: view.frame.width, height: view.frame.height - 100))
        viewOption1.backgroundColor = .red
        viewOption2 = UIView(frame: CGRect(x: 0, y: 140, width: view.frame.width, height: view.frame.height - 100))
        viewOption3 = UIView(frame: CGRect(x: 0, y: 140, width: view.frame.width, height: view.frame.height - 100))
        
        view.addSubview(viewOption1)
        viewOption1.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 100).isActive = true
        containerStackView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor, constant: 5).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: segmentedControl.rightAnchor, constant: -5).isActive = true
        [passwordTextField, repeatPasswordTextField].forEach {
            containerStackView.addArrangedSubview($0)
        }
        viewOption1.addSubview(acceptButton)
        acceptButton.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor, constant: 5).isActive = true
        acceptButton.rightAnchor.constraint(equalTo: segmentedControl.rightAnchor, constant: -5).isActive = true
        acceptButton.bottomAnchor.constraint(equalTo: viewOption1.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        
        
        view.addSubview(viewOption2)
        viewOption2.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(viewOption3)
        
        
        viewOption2.isHidden = true
        viewOption3.isHidden = true
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
