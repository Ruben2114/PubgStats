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
        search.placeholder = "Nombre de usuarios Pubg"
        search.translatesAutoresizingMaskIntoConstraints = false
        search.backgroundColor = .systemGroupedBackground
        return search
    }()
    private lazy var tableView = makeTableViewGroup()
    private var profilesFavourite: [Favourite] = []
    private let dependencies: FavouriteDependency
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: FavouriteViewModel
    private let sessionUser: ProfileEntity
    
    init(dependencies: FavouriteDependency) {
        self.dependencies = dependencies
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
        configConstraint()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchFavourite()
    }
    private func searchFavourite(){
        guard let favourite = viewModel.getFavourites(for: sessionUser) else {return}
        profilesFavourite = favourite
        tableView.reloadData()
    }
    
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .fail(_):
                self?.hideSpinner()
                self?.presentAlert(message: "El nombre de usuario no existe", title: "Error")
            case .success(_):
                let directorio = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        print(directorio)
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
        navigationItem.title = "Tus usuarios preferidos"
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

extension FavouriteViewController: SpinnerDisplayable{ }
extension FavouriteViewController: MessageDisplayable{ }
extension FavouriteViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        guard let text = searchBar.text else { return }
        var modelNames: [String] = []
        for fav in profilesFavourite {
            guard let modelName = fav.name else {return}
            modelNames.append(modelName)
        }
        guard modelNames.contains(text) != true else {
            presentAlert(message: "Ya tienes en tu lista a un usuario con ese nombre", title: "Error")
            return
        }
        viewModel.searchFav(name: text)
        searchBar.text = ""
    }
}
extension FavouriteViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if profilesFavourite.isEmpty {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            messageLabel.text = "Puedes añadir aqui tus perfiles favoritos"
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.sizeToFit()
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
        let accountModel = profilesFavourite[indexPath.row].account
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont.systemFont(ofSize: 20)
        //TODO: crear tabla donde se vean mas datos, tipo level, muertes... creada en xib en tableviewcell/common
        listContent.text = nameModel
        listContent.secondaryText = accountModel
        cell.contentConfiguration = listContent
        return cell
    }
}
extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(
            style: .destructive,
            title: "Borrar",
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
