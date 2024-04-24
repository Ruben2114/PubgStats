//
//  HelpDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import Combine


final class HelpDataViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
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
    private let viewModel: HelpDataViewModel
    
    init(dependencies: HelpDataDependencies) {
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
}

private extension HelpDataViewController {
    func configUI() {
        configureImageBackground("")
        titleNavigation("helpDataViewControllerTitle", backButton: #selector(backButtonAction))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
   
    @objc private func backButtonAction() {
        viewModel.backButton()
    }
}

extension HelpDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        ItemCellHelpData.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGray.withAlphaComponent(0.8)
        cell.selectionStyle = .none
        let itemCellHelpData = ItemCellHelpData.allCases[indexPath.section]
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont(name: "AmericanTypewriter-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        listContent.textProperties.color = .white
        listContent.text = itemCellHelpData.question()
        listContent.textProperties.alignment = .center
        listContent.secondaryTextProperties.font = UIFont(name: "AmericanTypewriter", size: 16) ?? UIFont.systemFont(ofSize: 16)
        listContent.secondaryText = itemCellHelpData.response()
        listContent.secondaryTextProperties.alignment = .center
        listContent.secondaryTextProperties.color = .white
        cell.contentConfiguration = listContent
        return cell
    }
}
