//
//  GamesModesDataDetailViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

class GamesModesDataDetailViewController: UIViewController {
    private lazy var tableView = makeTableViewData()
    private let viewModel: GamesModesDataDetailViewModel
    private let dependencies: GamesModesDataDetailDependency
    private let sessionUser: ProfileEntity
    private let imageView = UIImageView(image: UIImage(named: "backgroundGamesMode"))
    
    init(dependencies: GamesModesDataDetailDependency) {
        self.dependencies = dependencies
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
        bind()
    }
    private func bind() {
        viewModel.fetchDataGamesModesDetail()
        tableView.reloadData()
    }
    
    private func configUI(){
        view.backgroundColor = .systemBackground
        title = "gamesModesDataDetailViewControllerTitle".localize() + "\(sessionUser.gameMode ?? "")"
        backButton(action: #selector(backButtonAction))
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        configConstraint()
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
    @objc private func backButtonAction() {
        viewModel.backButton()
    }
}
extension GamesModesDataDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataGamesModes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let model = viewModel.dataGamesModes.map { $0.0 }
        let sortedModel = model.sorted()
        let sortedDataGamesModes = sortedModel.map { key in
            let value = viewModel.dataGamesModes.first(where: { $0.0 == key })!.1
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
