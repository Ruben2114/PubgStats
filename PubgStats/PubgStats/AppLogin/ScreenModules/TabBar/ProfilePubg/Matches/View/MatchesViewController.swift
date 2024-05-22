//
//  MatchesViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 9/4/24.
//

import UIKit
import Combine

final class MatchesViewController: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: MatchesViewModel
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
    private lazy var messageEmptyLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .white
        messageLabel.font = ConstantFormat.largeFontBold
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        return messageLabel
    }()
    
    private let cellIdentifier = "MatchesViewCell"
    private var errorMatches: Bool = false
    private var matchesList: [MatchRepresentable] = []
    
    private enum Constant {
        static let spacing: CGFloat = 16
        static let tableViewBottom: CGFloat = 24
    }
    
    init(dependencies: MatchesDependencies) {
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

private extension MatchesViewController {
    func setAppearance() {
        configureImageBackground("matchesBackground")
        setupTableView()
        showLoading()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "MatchesTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constant.tableViewBottom, right: 0)
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .showMatches(let matches):
                self?.matchesList = matches ?? []
                self?.tableView.reloadData()
                self?.hideLoading()
            case .showErrorMatches:
                self?.errorMatches = true
                self?.tableView.reloadData()
                self?.hideLoading()
            }
        }.store(in: &cancellable)
    }
    
    func configureNavigationBar() {
        titleNavigation("matchesViewControllerTitle".localize(), backButton: #selector(backButtonAction))
    }
    
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}

extension MatchesViewController: LoadingPresentationDisplayable { }
extension MatchesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageEmptyLabel.text = errorMatches ? "matchesTableViewError".localize() : "matchesTableViewEmpty".localize()
        let container = messageEmptyLabel.embedIntoView(leftMargin: Constant.spacing, rightMargin: Constant.spacing)
        tableView.backgroundView = matchesList.isEmpty || errorMatches ? container : nil
        return matchesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MatchesTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        let match = matchesList.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })[indexPath.row]
        cell.configureWith(representable: match)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
