//
//  StatsGeneralViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

import UIKit
import Combine

final class StatsGeneralViewController: UIViewController {
    private lazy var tableView = makeTableView()
    private lazy var levelLabel = makeLabelStats(height: 78)
    private lazy var nameLabel = makeLabelStats(height: 21)
    private lazy var xpLabel = makeLabelStats(height: 21)
    private lazy var stackStackView = makeStack(space: 5)
    private lazy var labelFirstStackView = makeStackHorizontal(space: 5)
    private lazy var winsLabel = makeLabelStats(height: 65)
    private lazy var killsLabel = makeLabelStats(height: 65)
    private lazy var top10sLabel = makeLabelStats(height: 65)
    private lazy var labelSecondStackView = makeStackHorizontal(space: 5)
    private lazy var gamesPlayedLabel = makeLabelStats(height: 65)
    private lazy var timePlayedLabel = makeLabelStats(height: 65)
    private lazy var bestRankedLabel = makeLabelStats(height: 65)
    
    private var cancellable = Set<AnyCancellable>()
    private let dependencies: StatsGeneralDependency
    private let viewModel: StatsGeneralViewModel
    let sessionUser: ProfileEntity
    var refreshCount = 0
    var reloadButton = UIBarButtonItem()
    
    init(dependencies: StatsGeneralDependency) {
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
        configConstraints()
        bind()
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self ] state in
                switch state {
                case .loading:
                    self?.showSpinner()
                case .fail(_):
                    self?.presentAlert(message: "Por favor debes esperar x tiempo para hacer la siguiente llamada", title: "Error")
                    self?.hideSpinner()
                case .successSurvival(model: let model):
                    self?.xpLabel.text = "\(model.data.attributes.xp) XP"
                    self?.levelLabel.text = "Nivel\n\(model.data.attributes.level)"
                case .successGamesModes(model: let model):
                    self?.killsLabel.text = "\(model.killsTotal)\nMuertes"
                    self?.top10sLabel.text = "\(model.top10STotal)\nTop10S"
                    self?.gamesPlayedLabel.text = "\(model.gamesPlayed)\nPartidas"
                    self?.winsLabel.text = "\(model.wonTotal)\nVictorias"
                    self?.timePlayedLabel.text = "\(model.timePlayed)\nTiempo Jugado"
                    self?.bestRankedLabel.text = "\(Int(model.bestRank))\nMejor ranked"
                case .success:
                    self?.hideSpinner()
                case .getSurvival(model: let model):
                    self?.xpLabel.text = "\(model?.xp ?? "0") XP"
                    self?.levelLabel.text = "Nivel\n\(model?.level ?? "0")"
                case .getGamesMode(model: let model):
                    self?.killsLabel.text = "\(model?[0].killsTotal ?? 0)\nMuertes"
                    self?.top10sLabel.text = "\(model?[0].top10STotal ?? 0)\nTop10S"
                    self?.gamesPlayedLabel.text = "\(model?[0].gamesPlayed ?? 0)\nPartidas"
                    self?.winsLabel.text = "\(model?[0].wonTotal ?? 0)\nVictorias"
                    self?.timePlayedLabel.text = "\(model?[0].timePlayed ?? "0")\nTiempo Jugado"
                    self?.bestRankedLabel.text = "\(model?[0].bestRankPoint ?? 0)\nMejor ranked"
                case .getName(model: let model):
                    self?.nameLabel.text = model
                }
            }.store(in: &cancellable)
        viewModel.viewDidLoad()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Tus Estadisticas generales"
        backButton(action: #selector(backButtonAction))
        reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise.circle.fill"), style: .plain, target: self, action: #selector(reloadButtonAction))
        navigationItem.rightBarButtonItem = reloadButton
        stackStackView.backgroundColor = .systemCyan
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func configConstraints() {
        view.addSubview(levelLabel)
        levelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(xpLabel)
        xpLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        xpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(stackStackView)
        stackStackView.topAnchor.constraint(equalTo: xpLabel.bottomAnchor, constant: 30).isActive = true
        stackStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        stackStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        [labelFirstStackView, labelSecondStackView].forEach {
            stackStackView.addArrangedSubview($0)
        }
        
        [winsLabel,killsLabel, top10sLabel].forEach {
            labelFirstStackView.addArrangedSubview($0)
        }
        
        [gamesPlayedLabel,timePlayedLabel,bestRankedLabel].forEach {
            labelSecondStackView.addArrangedSubview($0)
        }
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: stackStackView.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func backButtonAction() {
        viewModel.backButton()
    }
    @objc func reloadButtonAction() {
        guard refreshCount == 1 else {
            reloadButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 120) {
                self.reloadButton.isEnabled = true
                self.refreshCount = 0
            }
            refreshCount += 1
            viewModel.reload()
            return
        }
    }
}
extension StatsGeneralViewController: MessageDisplayable { }
extension StatsGeneralViewController: SpinnerDisplayable { }
extension StatsGeneralViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemCellStats.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let itemCellStats = viewModel.itemCellStats[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont.systemFont(ofSize: 20)
        listContent.text = itemCellStats.title()
        listContent.textProperties.alignment = .center
        listContent.image =  UIImage(named: itemCellStats.image())
        listContent.imageProperties.reservedLayoutSize = CGSize(width: 50, height: 50)
        cell.contentConfiguration = listContent
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemCellStats = viewModel.itemCellStats[indexPath.row]
        switch itemCellStats {
        case .dataKill:
            viewModel.goKillsData()
        case .dataWeapon:
            viewModel.goWeapons()
        case .dataSurvival:
            viewModel.goSurvival()
        case .dataGamesModes:
            viewModel.goGamesModes()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
