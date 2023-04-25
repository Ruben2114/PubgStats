//
//  HelpDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import Combine


final class HelpDataViewController: UIViewController {
    private lazy var tableView = makeTableView()
    private let viewModel: HelpDataViewModel
    private let sessionUser: ProfileEntity
    
    init(dependencies: HelpDataDependency) {
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
        configConstraints()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "helpDataViewControllerTitle".localize()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        backButton(action: #selector(backButtonAction))
    }
    
    private func configConstraints(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
   
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}

extension HelpDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemCellHelpData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let itemCellHelpData = viewModel.itemCellHelpData[indexPath.row]
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        listContent.text = itemCellHelpData.question()
        listContent.textProperties.alignment = .center
        listContent.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16)
        listContent.secondaryText = itemCellHelpData.response()
        listContent.secondaryTextProperties.alignment = .center
        cell.contentConfiguration = listContent
        return cell
    }
}
