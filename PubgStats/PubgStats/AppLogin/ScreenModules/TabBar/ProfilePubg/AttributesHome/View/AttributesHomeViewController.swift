//
//  AttributesHomeViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit
import Combine

class AttributesHomeViewController: UIViewController {
    private let cellIdentifier = "AttributesHomeViewCell"
    private lazy var imageBackground: UIImageView = {
        UIImageView()
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return tableView
    }()
    
    private var listAttributes: [AttributesHome] = []
    private let viewModel: AttributesHomeViewModel
    private let dependencies: AttributesHomeDependencies
    private var cancellable = Set<AnyCancellable>()
    
    init(dependencies: AttributesHomeDependencies) {
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
        configureNavigationBar()
    }
}

private extension AttributesHomeViewController {
    func setAppearance() {
        setupTableView()
    }
    
    func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] representable in
                self?.listAttributes = representable ?? []
                self?.tableView.reloadData()
            }.store(in: &cancellable)
    }
    
    func configureNavigationBar() {
        let image = viewModel.getType().getImage()
        imageBackground.image = UIImage(named: image)
        view.insertSubview(imageBackground, at: 0)
        imageBackground.frame = view.bounds
        titleNavigation(viewModel.getType().getTitle(), backButton: #selector(backButtonAction))
    }
    
    func setupTableView() {
        tableView.register(AttributesHomeViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
    
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}

extension AttributesHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AttributesHomeViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        let list = listAttributes.sorted { $0.title < $1.title}
        cell.configureWith(representable: list[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = listAttributes.sorted { $0.title < $1.title}[indexPath.row]
        viewModel.goToAttributesDetails(select)
    }
}
