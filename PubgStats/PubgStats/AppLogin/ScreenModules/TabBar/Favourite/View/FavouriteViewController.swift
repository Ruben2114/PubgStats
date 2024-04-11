//
//  FavouriteViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit
import Combine

class FavouriteViewController: UIViewController {
    private var filteredProfilesFavourite: [IdAccountDataProfileRepresentable] = []
    private let dependencies: FavouriteDependencies
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: FavouriteViewModel
    private lazy var messageEmptyLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "profilesFavouriteEmpty".localize()
        messageLabel.textColor = .white
        messageLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 25)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        return messageLabel
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "searchPlaceholder".localize()
        search.searchTextField.font = UIFont(name: "AmericanTypewriter", size: 16)
        search.translatesAutoresizingMaskIntoConstraints = false
        search.searchTextField.backgroundColor = .systemGroupedBackground
        search.backgroundImage = UIImage()
        search.barTintColor = .clear
        search.delegate = self
        return search
    }()
    
    init(dependencies: FavouriteDependencies) {
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

private extension FavouriteViewController {
    func setAppearance() {
        titleNavigation("favouriteViewControllerNavigationItem")
        configureImageBackground("backgroundFavourite")
        configView()
    }
    
    func configView() {
        tableView.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        configConstraint()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .showPlayerDetails(let data):
                self?.filteredProfilesFavourite = data.sorted { $0.name.lowercased() < $1.name.lowercased() }
                self?.tableView.reloadData()
            case .showError(let message, let players):
                self?.filteredProfilesFavourite = players.sorted { $0.name.lowercased() < $1.name.lowercased() }
                self?.tableView.reloadData()
                self?.presentAlert(message: message, title: "Error")
            }
        }.store(in: &cancellable)
    }
    
    func configConstraint() {
        view.addSubview(searchBar)
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension FavouriteViewController: MessageDisplayable{ }
extension FavouriteViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        guard var text = searchBar.text,
              !filteredProfilesFavourite.contains(where: {$0.name == text}) else { return }
        
        if text.contains(" ") {
            let updatedText = text.replacingOccurrences(of: " ", with: "%20")
            text = updatedText
        }
        searchBar.searchTextField.resignFirstResponder()
        //TODO: poner key
        presentAlertPlatform(title: "¿De qué plataforma?") { [weak self] platform in
            self?.viewModel.searchFavourite(name: text, platform: platform)
        }
        searchBar.text = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filterProfile = viewModel.profilesFavourite.filter{ $0.name.range(of: searchText, options: .caseInsensitive) != nil }
        filteredProfilesFavourite = searchText.isEmpty ? viewModel.profilesFavourite : filterProfile
        tableView.reloadData()
    }
}

extension FavouriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = viewModel.profilesFavourite.isEmpty ? messageEmptyLabel : nil
        return filteredProfilesFavourite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FavouriteTableViewCell else { return UITableViewCell() }
        let nameModel = filteredProfilesFavourite[indexPath.row]
        cell.configureWith(nameModel)
        cell.backgroundColor = .clear
        cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(
            style: .destructive,
            title: "profilesFavouriteDelete".localize(),
            handler: { [weak self] _, _, _  in
                guard let self else { return }
                let perfilFavorito = self.filteredProfilesFavourite[indexPath.row]
                self.viewModel.deleteFavourite(perfilFavorito)
                if let indice = self.filteredProfilesFavourite.firstIndex(where: {$0.name == perfilFavorito.name}) {
                    self.filteredProfilesFavourite.remove(at: indice)
                    self.viewModel.updateProfilesFavourite(perfilFavorito.name)
                    self.tableView.deleteRows(at: [IndexPath(row: indice, section: 0)], with: .automatic)
                    self.tableView.reloadData()
                }
            })
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FavouriteTableViewCell {
            cell.superview?.subviews.forEach { swipe in
                if type(of: swipe.self).description() == "UISwipeActionPullView" {
                    swipe.frame.size.height = cell.getHeightContainer()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = filteredProfilesFavourite[indexPath.row]
        viewModel.goToProfile(favourite)
    }
}
