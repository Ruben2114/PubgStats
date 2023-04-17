//
//  InfoAppViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

import UIKit

class InfoAppViewController: UIViewController {
    private lazy var infoLabel = makeLabel(title: viewModel.info, color: .black, font: 17, style: .body)
    private let viewModel: InfoAppViewModel
    
    init(dependencies: InfoAppDependency) {
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configConstraints()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Aviso Legal"
        backButton(action: #selector(backButtonAction))
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func configConstraints(){
        view.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}

