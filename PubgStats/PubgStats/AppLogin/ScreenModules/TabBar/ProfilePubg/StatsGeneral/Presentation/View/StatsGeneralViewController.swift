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
    private lazy var levelLabel = makeLabelStatsLevel(height: 80, width: 80)
    private lazy var nameLabel = makeLabelStats(height: 21)
    private lazy var xpLabel = makeLabelStats(height: 21)
    private lazy var stackStackView = makeStack(space: 5)
    private lazy var labelFirstStackView = makeStackHorizontal(space: 5)
    private lazy var winsLabel = makeLabelStatsBoder(height: 65)
    private lazy var killsLabel = makeLabelStatsBoder(height: 65)
    private lazy var assistsLabel = makeLabelStatsBoder(height: 65)
    private lazy var labelSecondStackView = makeStackHorizontal(space: 5)
    private lazy var gamesPlayedLabel = makeLabelStatsBoder(height: 65)
    private lazy var timePlayedLabel = makeLabelStatsBoder(height: 65)
    private lazy var bestRankedLabel = makeLabelStatsBoder(height: 65)
    private lazy var radarChartView: RadarChartView = {
        let radar = RadarChartView()
        radar.translatesAutoresizingMaskIntoConstraints = false
        radar.backgroundColor = .clear
        radar.values = viewModel.valuesRadarChart()
        radar.labels = viewModel.dataRadarChart()
        return radar
    }()
    var contentView: UIView = UIView()
    var mainScrollView: UIScrollView = UIScrollView()
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
                case .success:
                    self?.hideSpinner()
                case .getSurvival(model: let model):
                    self?.xpLabel.text = "\(model?.xp ?? "0") XP"
                    self?.levelLabel.text = "Nivel\n\(model?.level ?? "0")"
                case .getGamesMode(model: let model):
                    self?.killsLabel.text = "\(model?[0].killsTotal ?? 0)\nMuertes"
                    self?.assistsLabel.text = "\(model?[0].assistsTotal ?? 0)\nAsistencias"
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
        tableView.dataSource = self
        tableView.delegate = self
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        tableView.isScrollEnabled = false
        configScroll()
    }
    private func configConstraints() {
        contentView.addSubview(levelLabel)
        levelLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 22).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(xpLabel)
        xpLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        xpLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(stackStackView)
        stackStackView.topAnchor.constraint(equalTo: xpLabel.bottomAnchor, constant: 30).isActive = true
        stackStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        stackStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        [labelFirstStackView, labelSecondStackView].forEach {
            stackStackView.addArrangedSubview($0)
        }
        
        [winsLabel,killsLabel, assistsLabel].forEach {
            labelFirstStackView.addArrangedSubview($0)
        }
        
        [gamesPlayedLabel,timePlayedLabel,bestRankedLabel].forEach {
            labelSecondStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(radarChartView)
        radarChartView.topAnchor.constraint(equalTo: stackStackView.bottomAnchor, constant: 20).isActive = true
        radarChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        radarChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        radarChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        contentView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: radarChartView.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 272).isActive = true
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
extension StatsGeneralViewController: ViewScrollable { }
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
        listContent.imageProperties.reservedLayoutSize = CGSize(width: 40, height: 40)
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
}

/*
 import UIKit
 import Combine
 
 final class StatsGeneralViewController: UIViewController {
 private lazy var tableView = makeTableView()
 private lazy var levelLabel = makeLabelStatsLevel(height: 80, width: 80)
 private lazy var nameLabel = makeLabelStats(height: 21)
 private lazy var xpLabel = makeLabelStats(height: 21)
 //private lazy var stackStackView = makeStack(space: 5)
 private lazy var labelFirstStackView = makeStackHorizontal(space: 5)
 private lazy var winsLabel = makeLabelStatsBoder(height: 65)
 private lazy var killsLabel = makeLabelStatsBoder(height: 65)
 private lazy var assistsLabel = makeLabelStatsBoder(height: 65)
 private lazy var labelSecondStackView = makeStack(space: 5)
 private lazy var gamesPlayedLabel = makeLabelStatsBoder(height: 65)
 private lazy var timePlayedLabel = makeLabelStatsBoder(height: 65)
 private lazy var bestRankedLabel = makeLabelStatsBoder(height: 65)
 
 private lazy var radarChartView: RadarChartView = {
 let radar = RadarChartView()
 radar.translatesAutoresizingMaskIntoConstraints = false
 radar.backgroundColor = .clear
 radar.values = [0.2,0.3,0.8,0.9,0.5]
 radar.labels = viewModel.dataRadarChart()
 return radar
 }()
 
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
 // TODO: poner abreviaturas y un boton de ? donde explique las abreviaturas
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
 self?.assistsLabel.text = "\(model.assistsTotal)\nAsistencias"
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
 self?.assistsLabel.text = "\(model?[0].assistsTotal ?? 0)\nAsistencias"
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
 tableView.dataSource = self
 tableView.delegate = self
 nameLabel.font = UIFont.systemFont(ofSize: 25)
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
 
 view.addSubview(labelFirstStackView)
 labelFirstStackView.topAnchor.constraint(equalTo: xpLabel.bottomAnchor, constant: 30).isActive = true
 labelFirstStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
 labelFirstStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
 
 [winsLabel,killsLabel, assistsLabel].forEach {
 labelFirstStackView.addArrangedSubview($0)
 }
 
 view.addSubview(labelSecondStackView)
 labelSecondStackView.topAnchor.constraint(equalTo: labelFirstStackView.bottomAnchor, constant: 5).isActive = true
 labelSecondStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
 labelSecondStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33).isActive = true
 
 [gamesPlayedLabel,timePlayedLabel,bestRankedLabel].forEach {
 labelSecondStackView.addArrangedSubview($0)
 }
 
 
 view.addSubview(radarChartView)
 radarChartView.topAnchor.constraint(equalTo: labelSecondStackView.topAnchor, constant: 10).isActive = true
 radarChartView.leadingAnchor.constraint(equalTo: labelSecondStackView.trailingAnchor).isActive = true
 radarChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
 radarChartView.heightAnchor.constraint(equalTo: labelSecondStackView.heightAnchor).isActive = true
 
 
 
 view.addSubview(tableView)
 tableView.topAnchor.constraint(equalTo: labelSecondStackView.bottomAnchor, constant: 20).isActive = true
 tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
 tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
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
 listContent.imageProperties.reservedLayoutSize = CGSize(width: 40, height: 40)
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
 }
 
 */
/*
 //
 //  StatsGeneralViewController.swift
 //  PubgStats
 //
 //  Created by Rubén Rodríguez Cervigón on 29/3/23.
 //
 
 import UIKit
 import Combine
 enum ItemCollectionStats{
 case killsLabel
 case assistsLabel
 case gamesPlayedLabel
 case winsLabel
 case timePlayedLabel
 case bestRankedLabel
 func title() -> String{
 switch self{
 case .killsLabel:
 return "Muertes"
 case .assistsLabel:
 return "Asistencias"
 case .gamesPlayedLabel:
 return "Partidas"
 case .winsLabel:
 return "Victorias"
 case .timePlayedLabel:
 return "Tiempo jugado"
 case .bestRankedLabel:
 return "Mejor ranked"
 }
 }
 }
 
 final class StatsGeneralViewController: UIViewController {
 private lazy var collectionView: UICollectionView = {
 let layout = UICollectionViewFlowLayout()
 let layoutWidth = view.bounds.width / 2
 layout.itemSize = CGSize(width: layoutWidth, height: 40)
 layout.minimumLineSpacing = .zero
 layout.minimumInteritemSpacing = .zero
 layout.scrollDirection = .vertical
 let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
 collectionView.translatesAutoresizingMaskIntoConstraints = false
 return collectionView
 }()
 
 var killsLabel: String = ""
 var assistsLabel: String = ""
 var gamesPlayedLabel: String = ""
 var winsLabel: String = ""
 var timePlayedLabel: String = ""
 var bestRankedLabel: String = ""
 private var itemCollectionStats: [ItemCollectionStats] = [ItemCollectionStats.winsLabel, ItemCollectionStats.killsLabel, ItemCollectionStats.assistsLabel, ItemCollectionStats.gamesPlayedLabel, ItemCollectionStats.timePlayedLabel, ItemCollectionStats.bestRankedLabel]
 private var dataCollection: [String] = ["A: 20%", "B: 30%", "C: 80%", "D: 90%", "E: 50%", "E: 50%"]
 
 
 private lazy var tableView = makeTableView()
 private lazy var levelLabel = makeLabelStatsLevel(height: 80, width: 80)
 private lazy var nameLabel = makeLabelStats(height: 21)
 private lazy var xpLabel = makeLabelStats(height: 21)
 private lazy var radarChartView: RadarChartView = {
 let radar = RadarChartView()
 radar.translatesAutoresizingMaskIntoConstraints = false
 radar.backgroundColor = .clear
 radar.values = [0.2,0.3,0.8,0.9,0.5]
 radar.labels = ["A: 20%", "B: 30%", "C: 80%", "D: 90%", "E: 50%"]
 return radar
 }()
 
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
 self?.dataCollection = ["\(model.killsTotal)", "\(model.assistsTotal)","\(model.gamesPlayed)","\(model.wonTotal)","\(model.timePlayed)","\(model.bestRank)"]
 self?.collectionView.reloadData()
 case .success:
 self?.hideSpinner()
 case .getSurvival(model: let model):
 self?.xpLabel.text = "\(model?.xp ?? "0") XP"
 self?.levelLabel.text = "Nivel\n\(model?.level ?? "0")"
 case .getGamesMode(model: let model):
 self?.dataCollection = ["\(model?[0].killsTotal ?? 0)", "\(model?[0].assistsTotal ?? 0)","\(model?[0].gamesPlayed ?? 0)","\(model?[0].wonTotal ?? 0)","\(model?[0].timePlayed ?? "0")","\(model?[0].bestRankPoint ?? 0)"]
 self?.collectionView.reloadData()
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
 tableView.dataSource = self
 tableView.delegate = self
 nameLabel.font = UIFont.systemFont(ofSize: 25)
 collectionView.dataSource = self
 collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
 
 
 view.addSubview(collectionView)
 collectionView.topAnchor.constraint(equalTo: xpLabel.bottomAnchor, constant: 20).isActive = true
 collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
 collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
 collectionView.layoutIfNeeded()
 let collectionViewHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
 collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true
 
 
 view.addSubview(radarChartView)
 radarChartView.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
 radarChartView.leadingAnchor.constraint(equalTo: collectionView.trailingAnchor).isActive = true
 radarChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
 radarChartView.heightAnchor.constraint(equalTo: collectionView.heightAnchor).isActive = true
 
 view.addSubview(tableView)
 tableView.topAnchor.constraint(equalTo: radarChartView.bottomAnchor, constant: 10).isActive = true
 tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
 tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
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
 listContent.imageProperties.reservedLayoutSize = CGSize(width: 40, height: 40)
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
 }
 
 extension StatsGeneralViewController: UICollectionViewDataSource {
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 itemCollectionStats.count
 }
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
 cell.backgroundColor = .systemBackground
 let model = itemCollectionStats[indexPath.row]
 let data = dataCollection[indexPath.row]
 var listContent = UIListContentConfiguration.cell()
 listContent.text = "\(model.title()): \(data)"
 listContent.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
 listContent.textProperties.color = .black
 listContent.textProperties.numberOfLines = 0
 cell.contentConfiguration = listContent
 return cell
 }
 }
 
 
 
 
 
 */
