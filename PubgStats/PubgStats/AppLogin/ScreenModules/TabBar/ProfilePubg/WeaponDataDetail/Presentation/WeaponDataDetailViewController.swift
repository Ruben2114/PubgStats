//
//  WeaponDataDetailViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

import UIKit

class WeaponDataDetailViewController: UIViewController {
    private lazy var tableView = makeTableView()
    private let viewModel: WeaponDataDetailViewModel
    private let dependencies: WeaponDataDetailDependency
    private let sessionUser: ProfileEntity
    init(dependencies: WeaponDataDetailDependency) {
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
        configUI()
        configConstraint()
        bind()
    }
    func bind() {
        viewModel.fetchDataWeaponDetail()
        tableView.reloadData()
    }
    
    func configUI(){
        view.backgroundColor = .systemBackground
        guard let weapon = sessionUser.weapon else {return}
        title = "weaponDataDetailViewControllerTitle".localize() + "\(weapon)"
        backButton(action: #selector(backButtonAction))
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
    }
    func configConstraint(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}

extension WeaponDataDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataWeaponDetail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = viewModel.dataWeaponDetail.map { $0.0 }
        let sortedModel = model.sorted()
        let sortedDataGamesModes = sortedModel.map { key in
            let value = viewModel.dataWeaponDetail.first(where: { $0.0 == key })!.1
            return (key, value)
        }
        let item = sortedDataGamesModes[indexPath.row]
        let contentItem = item.0 + ": " + String(describing: item.1)
        var listContent = UIListContentConfiguration.cell()
        listContent.text = contentItem
        cell.contentConfiguration = listContent
        return cell
    }
}

