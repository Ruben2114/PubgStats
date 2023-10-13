//
//  ProfilePubgViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {
    
    private let imageView = UIImageView(image: UIImage(named: "backgroundProfile"))
    private lazy var nameLabel = makeLabelProfile(title: "sessionUser.name", color: .black, font: 20, style: .title2, isBold: true)
    private lazy var emailLabel = makeLabelProfile(title:" sessionUser.email", color: .black, font: 20, style: .title2, isBold: false)
    
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private let dependencies: ProfileDependency
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(with: self.view)
        view.setScrollInsect(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        return view
    }()
    
    init(dependencies: ProfileDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //crear componente y meter aqui la barra de navegacion
    }
}

private extension ProfileViewController {
    func setAppearance() {
        configView()
        addViewToScrollableStackView()
    }
    
    func configView() {
        navigationItem.title = "profileViewControllerNavigationItem".localize()
        backButton(action: #selector(backButtonAction))
        //self.view.backgroundColor = .white
        self.view.insertSubview(imageView, at: 0)
        self.imageView.frame = view.bounds
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            }
        }.store(in: &cancellable)
    }
    
    func addViewToScrollableStackView() {
        scrollableStackView.addArrangedSubview(nameLabel)
        scrollableStackView.addArrangedSubview(emailLabel)
    }
    
    @objc func backButtonAction() {
        let alert = UIAlertController(title: "alertTitle".localize(), message: "profileBackButtonAction".localize(), preferredStyle: .alert)
        let actionAccept = UIAlertAction(title: "actionAccept".localize(), style: .default) { [weak self]_ in
            self?.viewModel.backButton()
        }
        let actionCancel = UIAlertAction(title: "actionCancel".localize(), style: .destructive)
        alert.addAction(actionAccept)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
}

extension ProfileViewController: MessageDisplayable { }
