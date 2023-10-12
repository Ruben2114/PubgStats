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
    private lazy var tableView = makeTableViewGroup()
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private let dependencies: ProfileDependency
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
        configUI()
        bind()
    }
    
    private func configUI() {
        view.backgroundColor = tableView.backgroundColor
        navigationItem.title = "profileViewControllerNavigationItem".localize()
        backButton(action: #selector(backButtonAction))
     
        tableView.backgroundColor = .clear
        configConstraints()
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .sendInfoProfile(_):
                self?.tableView.reloadData()
            case .sendInfoProfileError:
                self?.presentAlert( message: "", title: "Error")
            }
        }.store(in: &cancellable)
    }
    
    private func configConstraints() {
        view.insertSubview(imageView, at: 0)
        imageView.frame = view.bounds
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
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
    @objc private func backButtonAction() {
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
