//
//  LoginViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private lazy var containerStackView = makeStack(space: 20)
    private lazy var userTextField = makeTextFieldLogin(placeholder: "userTextField".localize(), isSecure: false)
    private lazy var segmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Steam", "Survival"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.layer.cornerRadius = 15
        segmented.layer.borderColor = UIColor.orange.cgColor
        segmented.layer.borderWidth = 1
        segmented.backgroundColor = .systemGray2
        segmented.selectedSegmentTintColor = .black
        segmented.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()
    private lazy var loginButton: UIButton = makeButtonBlue(title: "titleLoginButton".localize())
    private lazy var imageView: UIImageView = {
        return UIImageView(image: UIImage(named: "backgroundPubg"))
    }()
    private var platform: String = "steam"
    
    private let viewModel: LoginViewModel
    private var dependencies: LoginDependency
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    
    init(dependencies: LoginDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bind()
        viewModel.viewDidLoad()
    }
}

private extension LoginViewController {
    func configUI() {
        view.backgroundColor = .systemBackground
        configScroll()
        configKeyboardSubscription(mainScrollView: mainScrollView)
        hideKeyboard()
        configConstraints()
        configGradientForTitle()
        configTargets()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .sendInfoProfile(let data):
                self?.hideSpinner()
                self?.viewModel.goToProfile(player: data.name ?? "", id: data.id ?? "")
            case .sendInfoProfileError:
                self?.hideSpinner()
                self?.presentAlert(message: "El player no existe", title: "Error")
            case .showLoading:
                //TODO: cambiar el spinner por un lottie json
                self?.showSpinner()
            }
        }.store(in: &cancellable)
    }
    
    func configConstraints() {
        view.insertSubview(imageView, at: 0)
        imageView.frame = view.bounds
        
        contentView.addSubview(containerStackView)
        containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor).isActive = true
        
        [userTextField, segmentedControl, loginButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    
    func configGradientForTitle() {
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = view.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.darkGray.cgColor]
        gradientMaskLayer.locations = [0.0, 1.0]
        gradientMaskLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientMaskLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        view.layer.insertSublayer(gradientMaskLayer, at: 1)
    }
    
    func configTargets() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(changePlatform(_:)), for: .valueChanged)
    }
    
    @objc func didTapLoginButton() {
        guard let user = userTextField.text else{
            presentAlert(message: "profileLoginCellInvalid".localize(), title: "Error")
            return}
        viewModel.checkPlayer(player: user, platform: platform)
    }
    
    @objc func changePlatform(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.platform = "steam"
        case 1:
            self.platform = "xbox"
        default:
            break
        }
    }
}

extension LoginViewController: SpinnerDisplayable { }
extension LoginViewController: ViewScrollable {}
extension LoginViewController: MessageDisplayable { }
extension LoginViewController: KeyboardDisplayable {}

