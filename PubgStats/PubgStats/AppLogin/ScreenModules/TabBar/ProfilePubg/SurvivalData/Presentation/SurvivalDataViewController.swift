//
//  SurvivalDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import UIKit

class SurvivalDataViewController: UIViewController {
    private lazy var tableView = makeTableViewData()
    private let viewModel: SurvivalDataViewModel
    private let imageView = UIImageView(image: UIImage(named: "backgroundSurvival"))

    init(dependencies: SurvivalDataDependency) {
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
    }
    private func configUI(){
        title = "survivalDataViewControllerTitle".localize()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        backButton(action: #selector(backButtonAction))
        configConstraint()
        fetchData()
    }
    private func configConstraint(){
        view.insertSubview(imageView, at: 0)
        imageView.frame = view.bounds
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    private func fetchData() {
        viewModel.fetchDataSurvival()
        tableView.reloadData()
    }
    @objc private func backButtonAction() {
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
