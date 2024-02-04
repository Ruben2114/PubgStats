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
    private let emptyCellIdentifier = "AttributesHomeEmtpyViewCell"
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
    
    private var listAttributes: [AttributesViewRepresentable] = []
    private var type: AttributesType?
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
}

private extension AttributesHomeViewController {
    func setAppearance() {
        showSpinner()
        configureNavigationBar()
        setupTableView()
    }
    
    func configureNavigationBar() {
        backButton(action: #selector(backButtonAction))
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1),
            .font : UIFont(name: "AmericanTypewriter-Bold", size: 20) ?? UIFont.systemFont(ofSize: 16)
        ]
    }
    
    func bind() {
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type, representable in
                self?.listAttributes = representable
                self?.type = type
                self?.configureUI()
                self?.tableView.reloadData()
                self?.hideSpinner()
            }.store(in: &cancellable)
    }
    
    func configureUI() {
        let image = type?.getImage() ?? ""
        imageBackground.image = UIImage(named: image)
        view.insertSubview(imageBackground, at: 0)
        imageBackground.frame = view.bounds
        title = type?.getTitle()
    }
    
    func setupTableView() {
        registerCells()
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    func registerCells() {
        self.tableView.register(AttributesHomeViewCell.self, forCellReuseIdentifier: cellIdentifier)
        //self.tableView.register(AttributesHomeEmtpyViewCell.self, forCellReuseIdentifier: emptyCellIdentifier)
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
//        if listAttributes.count == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath) as? AttributesHomeEmtpyViewCell else {
//                return UITableViewCell()
//            }
//            cell.configurewith()
//            return cell
//        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AttributesHomeViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        cell.configureWith(representable: listAttributes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = listAttributes[indexPath.row]
        viewModel.goGameMode(representable: select)
    }
}

extension AttributesHomeViewController: SpinnerDisplayable { }
