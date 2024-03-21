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
        //TODO: meter esto dentro d eun stack y a este label darle fondo negro alpha 0.8 y corner del 8 para que se vea bien el label
        //TODO: otra opcion es crear un embedinto que se coloque en el centro de la view
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
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "searchPlaceholder".localize()
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
    private func setAppearance() {
        titleNavigation("favouriteViewControllerNavigationItem")
        configureImageBackground("backgroundFavourite")
        configView()
    }
    
    func configView() {
        showLoading()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        //TODO: falta bajar el keyboard
        //hideKeyboard()
        configConstraint()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .hideLoading:
                self?.hideLoading()
            case .showPlayerDetails(let data):
                self?.filteredProfilesFavourite = data
                self?.tableView.reloadData()
            case .showErrorSearchPlayer:
                self?.tableView.reloadData()
                self?.presentAlert(message: "error al cargar los datos", title: "Error")
            case .showErrorPlayerDetails:
                self?.tableView.reloadData()
                self?.presentAlert(message: "no existe un usuario con este nombre", title: "Error")
            }
        }.store(in: &cancellable)
    }
    
    private func configConstraint() {
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

extension FavouriteViewController: LoadingPresentationDisplayable{ }
extension FavouriteViewController: MessageDisplayable{ }
extension FavouriteViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        guard var text = searchBar.text,
              !filteredProfilesFavourite.contains(where: {$0.name == text}) else { return }
        
        if text.contains(" ") {
            let updatedText = text.replacingOccurrences(of: " ", with: "%20")
            text = updatedText
        }
        //TODO: poner key
        let alertController = UIAlertController(title: "¿De qué plataforma?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Steam", style: .default, handler: { (action) in
            self.showLoading()
            self.viewModel.searchFavourite(name: text, platform: "steam")
        }))
        alertController.addAction(UIAlertAction(title: "Xbox", style: .default, handler: { (action) in
            self.showLoading()
            self.viewModel.searchFavourite(name: text, platform: "xbox")
        }))
        present(alertController, animated: true, completion: nil)
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
        let nameModel = filteredProfilesFavourite.sorted { $0.name.lowercased() < $1.name.lowercased() }[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = filteredProfilesFavourite[indexPath.row]
        viewModel.goToProfile(favourite)
    }
}
