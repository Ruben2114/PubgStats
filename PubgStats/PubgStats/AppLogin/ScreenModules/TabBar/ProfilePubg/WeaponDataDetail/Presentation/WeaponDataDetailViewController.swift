//
//  WeaponDataDetailViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

import UIKit

class WeaponDataDetailViewController: UIViewController {
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private var weaponInfo: [(String, Any)] = []
    
    private let viewModel: WeaponDataDetailViewModel
    private let dependencies: WeaponDataDetailDependency
    private let sessionUser: ProfileEntity
    init(dependencies: WeaponDataDetailDependency) {
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
        fetchData()
    }
    func configUI(){
        view.backgroundColor = .systemBackground
        guard let weapon = sessionUser.weapon else {return}
        let weaponName = weapon.replacingOccurrences(of: "[Optional(\"", with: "").replacingOccurrences(of: "\")]", with: "")
        title = "Detalle Arma \(weaponName)"
        backButton(action: #selector(backButtonAction))
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func configConstraint(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    func fetchData() {
        guard let stats = sessionUser.weapons?.first?.data.attributes.weaponSummaries else {return}
            for value in stats {
                if value.key == sessionUser.weapon {
                    let xp = String(value.value.xpTotal)
                    let level = String(value.value.levelCurrent)
                    let tier = String(value.value.tierCurrent)
                    weaponInfo.append(("XP Total", xp))
                    weaponInfo.append(("Level Current", level))
                    weaponInfo.append(("Tier Current", tier))
                    for (key, value) in value.value.statsTotal {
                        weaponInfo.append((key, String(value)))
                    }
                }
            }
        tableView.reloadData()
    }
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}

extension WeaponDataDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weaponInfo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemCyan
        let model = weaponInfo[indexPath.row].0
        let model2 = weaponInfo.map{$0}[indexPath.row].1 as! String
        let model3 = model + ": " + model2
        var listContent = UIListContentConfiguration.cell()
        listContent.text = model3
        cell.contentConfiguration = listContent
        return cell
    }
}

