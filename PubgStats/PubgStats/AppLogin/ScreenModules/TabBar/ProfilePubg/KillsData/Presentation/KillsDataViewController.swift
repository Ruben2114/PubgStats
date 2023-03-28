//
//  KillsDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

class KillsDataViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let dependencies: KillsDataDependency
    private let viewModel: KillsDataViewModel
    init(dependencies: KillsDataDependency) {
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
        configConstraint()
        fetchData()
    }
    func configUI(){
        title = "Datos muertes totales"
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        backButton(action: #selector(backButtonAction))
    }
    func configConstraint(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    func fetchData() {
        viewModel.fetchDataKills()
        tableView.reloadData()
    }
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}

extension KillsDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataKillsDict.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemCyan
        let sortedDict = viewModel.dataKillsDict.sorted(by: { $0.key < $1.key})
        let contentItem = sortedDict.map{$0}[indexPath.row].key + ": " + String(sortedDict.map{$0}[indexPath.row].value)
        var listContent = UIListContentConfiguration.cell()
        listContent.text = contentItem
        cell.contentConfiguration = listContent
        return cell
    }
}
