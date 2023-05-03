//
//  KillsDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit

class KillsDataViewController: UIViewController {
    private lazy var tableView = makeTableViewData()
    private let imageView = UIImageView(image: UIImage(named: "backgroundKills"))
    private let dependencies: KillsDataDependency
    private let viewModel: KillsDataViewModel
    
    init(dependencies: KillsDataDependency) {
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
    }
    private func configUI(){
        title = "killsDataViewControllerTitle".localize()
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
        viewModel.fetchDataKills()
        tableView.reloadData()
    }
    @objc private func backButtonAction() {
        viewModel.backButton()
    }
}

extension KillsDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataKills.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sortedDataKills = viewModel.dataKills.sorted()
        let contentItem = sortedDataKills[indexPath.row]
        var listContent = UIListContentConfiguration.cell()
        listContent.text = contentItem
        cell.contentConfiguration = listContent
        return cell
    }
}
