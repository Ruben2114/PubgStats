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
    private lazy var imageFirstStackView = makeStackImage(space: 5)
    private lazy var winsImage = makeImageViewStats(name: "wonTotal", height: 65, label: winsLabel)
    private lazy var killsImage = makeImageViewStats(name: "wonTotal", height: 65, label: killsLabel)
    private lazy var assistsImage = makeImageViewStats(name: "wonTotal", height: 65, label: assistsLabel)
    private lazy var winsLabel = makeLabelImage()
    private lazy var killsLabel = makeLabelImage()
    private lazy var assistsLabel = makeLabelImage()
    private lazy var imageSecondStackView = makeStackImage(space: 5)
    private lazy var gamesPlayedImage = makeImageViewStats(name: "wonTotal", height: 65, label: gamesPlayedLabel)
    private lazy var timePlayedImage = makeImageViewStats(name: "wonTotal", height: 65, label: timePlayedLabel)
    private lazy var bestRankedImage = makeImageViewStats(name: "wonTotal", height: 65, label: bestRankedLabel)
    private lazy var gamesPlayedLabel = makeLabelImage()
    private lazy var timePlayedLabel = makeLabelImage()
    private lazy var bestRankedLabel = makeLabelImage()
    private lazy var radarChartView: RadarChartView = {
        let radar = RadarChartView(values: viewModel.valuesRadarChart, buttonsTitle: viewModel.titleRadarChart)
        radar.translatesAutoresizingMaskIntoConstraints = false
        radar.backgroundColor = .clear
        radar.buttons.forEach({ button in
            button.addTarget(self, action: #selector(handleMenuButtonTapped), for: .touchUpInside)
        })
        return radar
    }()
    private lazy var legendButton = legendButton()
    var contentView: UIView = UIView()
    var mainScrollView: UIScrollView = UIScrollView()
    private var cancellable = Set<AnyCancellable>()
    private let dependencies: StatsGeneralDependency
    private let viewModel: StatsGeneralViewModel
    private let sessionUser: ProfileEntity
    private var refreshCount = 0
    private var reloadButton = UIBarButtonItem()
    
    init(dependencies: StatsGeneralDependency) {
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
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self ] state in
                switch state {
                case .loading:
                    self?.showSpinner()
                case .fail(let error):
                    self?.presentAlert(message: error, title: "Error")
                    self?.hideSpinner()
                case .success:
                    self?.hideSpinner()
                case .getSurvival(model: let model):
                    self?.xpLabel.text = "\(model?.xp ?? "0") XP"
                    self?.levelLabel.text = "levelLabel".localize() + "\n\(model?.level ?? "0")"
                case .getGamesMode(model: let model):
                    self?.killsLabel.text = "\(model?[0].killsTotal ?? 0)\n" + "killsLabel".localize()
                    self?.assistsLabel.text = "\(model?[0].assistsTotal ?? 0)\n" + "assistsLabel".localize()
                    self?.gamesPlayedLabel.text = "\(model?[0].gamesPlayed ?? 0)\n" + "gamesPlayedLabel".localize()
                    self?.winsLabel.text = "\(model?[0].wonTotal ?? 0)\n" + "winsLabel".localize()
                    self?.timePlayedLabel.text = "\(model?[0].timePlayed ?? "0")\n" + "timePlayedLabel".localize()
                    self?.bestRankedLabel.text = "\(model?[0].bestRankPoint ?? 0)\n" + "bestRankedLabel".localize()
                case .getName(model: let model):
                    self?.nameLabel.text = model
                case .getItemRadarChar(title: let title, values: let values):
                    self?.radarChartView.reloadRadarChartView(title: title, values: values)
                }
            }.store(in: &cancellable)
        viewModel.viewDidLoad()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "statsGeneralViewControllerTitle".localize()
        backButton(action: #selector(backButtonAction))
        reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise.circle.fill"), style: .plain, target: self, action: #selector(reloadButtonAction))
        navigationItem.rightBarButtonItem = reloadButton
        tableView.dataSource = self
        tableView.delegate = self
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        tableView.isScrollEnabled = false
        configScroll()
        configConstraints()
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
        [imageFirstStackView, imageSecondStackView].forEach {
            stackStackView.addArrangedSubview($0)
        }
        
        [winsImage,killsImage, assistsImage].forEach {
            imageFirstStackView.addArrangedSubview($0)
        }
        
        [gamesPlayedImage,timePlayedImage,bestRankedImage].forEach {
            imageSecondStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(radarChartView)
        radarChartView.topAnchor.constraint(equalTo: stackStackView.bottomAnchor, constant: 20).isActive = true
        radarChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        radarChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        radarChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        contentView.addSubview(legendButton)
        legendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        legendButton.bottomAnchor.constraint(equalTo: radarChartView.bottomAnchor).isActive = true
        
        contentView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: radarChartView.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 272).isActive = true
    }
    @objc private func backButtonAction() {
        viewModel.backButton()
    }
    @objc private func reloadButtonAction() {
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
    @objc private func handleMenuButtonTapped(_ sender: UIButton) {
        let wins = createUIAction(title: "playerStatsVLabel".localize(), sender: sender, index: 0)
        let losses = createUIAction(title: "playerStatsDLabel".localize(), sender: sender, index: 1)
        let headshotKills = createUIAction(title: "playerStatsMDLabel".localize(), sender: sender, index: 2)
        let kills = createUIAction(title: "playerStatsKLabel".localize(), sender: sender, index: 3)
        let top10 = createUIAction(title: "playerStatsTLabel".localize(), sender: sender, index: 4)
        let menu = UIMenu(title: "Opciones", children: [wins, losses, headshotKills, kills, top10])
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
    private func createUIAction(title: String,sender: UIButton, index: Int) -> UIAction {
        let action = UIAction(title: title,handler: { [weak self] _ in
            sender.setTitle(self?.viewModel.titleRadarChart[index], for: .normal)
            guard let allValue = self?.viewModel.allDifferentValuesRadarChart, var value = self?.viewModel.valuesRadarChart else {return}
            value[sender.tag] = allValue[index]
            self?.viewModel.valuesRadarChart = value
            self?.radarChartView.values = value
            self?.radarChartView.setNeedsDisplay()
        })
        return action
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
