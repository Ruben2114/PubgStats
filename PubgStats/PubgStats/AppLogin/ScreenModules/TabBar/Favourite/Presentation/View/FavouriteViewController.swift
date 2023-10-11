//
//  FavouriteViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit
import Combine

class FavouriteViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "searchPlaceholder".localize()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.searchTextField.backgroundColor = .systemGroupedBackground
        search.backgroundImage = UIImage()
        search.barTintColor = .clear
        return search
    }()
    private lazy var tableView = makeTableViewGroup()
    private var profilesFavourite: [Favourite] = []
    private let dependencies: FavouriteDependency
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: FavouriteViewModel
    private let sessionUser: ProfileEntity
    private let imageView = UIImageView(image: UIImage(named: "backgroundCar"))
    
    init(dependencies: FavouriteDependency) {
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchFavourite()
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .fail(error: let error):
                self?.hideSpinner()
                self?.presentAlert(message: error, title: "Error")
            case .success(_):
                self?.searchFavourite()
                self?.hideSpinner()
                self?.tableView.reloadData()
            case .loading:
                self?.showSpinner()
            }
        }.store(in: &cancellable)
    }
    private func configUI() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "favouriteViewControllerNavigationItem".localize()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        hideKeyboard()
        configConstraint()
    }
    private func configConstraint() {
        view.insertSubview(imageView, at: 0)
        imageView.frame = view.bounds
        
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
    private func searchFavourite(){
        guard let favourite = viewModel.getFavourites(for: sessionUser) else {return}
        profilesFavourite = favourite
        tableView.reloadData()
    }
}

extension FavouriteViewController: SpinnerDisplayable{ }
extension FavouriteViewController: MessageDisplayable{ }
extension FavouriteViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        guard var text = searchBar.text else { return }
        var modelNames: [String] = []
        for fav in profilesFavourite {
            guard let modelName = fav.name else {return}
            modelNames.append(modelName)
        }
        guard modelNames.contains(text) != true else {
            presentAlert(message: "searchBarSearchButtonClickedError".localize(), title: "Error")
            return
        }
        if text.contains(" ") {
            let updatedText = text.replacingOccurrences(of: " ", with: "%20")
            text = updatedText
        }
        //TODO: meter title en localized y hacer generico este alertcontroller
        let alertController = UIAlertController(title: "¿De qué plataforma?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Steam", style: .default, handler: { (action) in
                self.viewModel.searchFav(name: text, platform: "steam")
        }))
        alertController.addAction(UIAlertAction(title: "Xbox", style: .default, handler: { (action) in
            self.viewModel.searchFav(name: text, platform: "xbox")
        }))
        present(alertController, animated: true, completion: nil)
        searchBar.text = ""
    }
}
extension FavouriteViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if profilesFavourite.isEmpty {
            let messageLabel = UILabel()
            messageLabel.text = "profilesFavouriteEmpty".localize()
            messageLabel.textColor = .white
            messageLabel.font = UIFont.boldSystemFont(ofSize: 25)
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return profilesFavourite.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let nameModel = profilesFavourite[indexPath.row].name
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont.systemFont(ofSize: 20)
        listContent.text = nameModel
        cell.contentConfiguration = listContent
        return cell
    }
}

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(
            style: .destructive,
            title: "profilesFavouriteDelete".localize(),
            handler: { _, _, _  in
                let perfilFavorito = self.profilesFavourite[indexPath.row]
                self.viewModel.deleteFavouriteTableView(perfilFavorito)
                if let indice = self.profilesFavourite.firstIndex(of: perfilFavorito) {
                    self.profilesFavourite.remove(at: indice)
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
        let row = indexPath.row
        let favourite = getItem(row: row)
        viewModel.goFavourite(favourite: favourite)
    }
    func getItem(row: Int) -> Favourite {
        let gameMode = profilesFavourite[row]
        return gameMode
    }
}
