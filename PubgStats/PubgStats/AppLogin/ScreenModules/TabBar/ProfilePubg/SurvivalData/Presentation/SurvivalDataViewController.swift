//
//  SurvivalDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import UIKit

class SurvivalDataViewController: UIViewController {
    private lazy var tableView = makeTableView()
    private let viewModel: SurvivalDataViewModel
    private let sessionUser: ProfileEntity
    init(dependencies: SurvivalDataDependency) {
        self.viewModel = dependencies.resolve()
        self.sessionUser = dependencies.external.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    @available(*,unavailable)
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
        title = "survivalDataViewControllerTitle".localize()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
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
        viewModel.fetchDataSurvival()
        tableView.reloadData()
    }
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}
extension SurvivalDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.content.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = viewModel.content.map { $0.0 }
        let sortedModel = model.sorted()
        let sortedDataGamesModes = sortedModel.map { key in
            let value = viewModel.content.first(where: { $0.0 == key })!.1
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
