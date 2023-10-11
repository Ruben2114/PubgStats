//
//  StatsGeneralViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

import UIKit
import Combine

final class StatsGeneralViewController: UIViewController {
    private let dataGeneralPlayer = DataGeneralPlayer()
    private lazy var stackView = createStackHorizontalButton(space: 10)
    private lazy var  buttonWeapons = createButtonStack(title: "Weapons", selector: #selector(didTapWeapons))
    private lazy var  buttonSurvival = createButtonStack(title: "Survival", selector: #selector(didTapSurvival))
    private lazy var  buttonModes = createButtonStack(title: "Modos", selector: #selector(didTapModes))
    private lazy var tableView = makeTableView()
    private lazy var levelLabel = makeLabelStatsLevel(height: 80, width: 80)
    private lazy var nameLabel = makeLabelStats(height: 21)
    private lazy var xpLabel = makeLabelStats(height: 21)
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
    private lazy var helpButton = helpButton(selector: #selector(helpButtonAction))
    var contentView: UIView = UIView()
    var mainScrollView: UIScrollView = UIScrollView()
    private var cancellable = Set<AnyCancellable>()
    private let dependencies: StatsGeneralDependency
    private let viewModel: StatsGeneralViewModel
    private let sessionUser: ProfileEntity
    private var refreshCount = 0
    private var reloadButton = UIBarButtonItem()
    private let userDefaults = UserDefaults.standard
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    //TODO: esto al viewModel
    private var interactiveChart = [
        PieChartViewData(centerIconKey: "star", centerTitleText: "2552", centerSubtitleText: "Kills Total", categories: [
            CategoryRepresentable(percentage: 60, color: .red, secundaryColor: .systemRed, currentCenterTitleText: "1111", currentSubTitleText: "TItle1", iconUrl: "star"),
            CategoryRepresentable(percentage: 30, color: .blue, secundaryColor: .systemBlue, currentCenterTitleText: "2222", currentSubTitleText: "TItle2", iconUrl: "star"),
            CategoryRepresentable(percentage: 10, color: .yellow, secundaryColor: .systemYellow, currentCenterTitleText: "3333", currentSubTitleText: "Muerte por disparo en la cabeza", iconUrl: "star")
        ], tooltipLabelTextKey: "Gráfica de las muertes totales"),
        PieChartViewData(centerIconKey: "star", centerTitleText: "10000", centerSubtitleText: "Muerte por disparo en la cabeza", categories: [
            CategoryRepresentable(percentage: 10, color: .gray, secundaryColor: .systemGray, currentCenterTitleText: "1000", currentSubTitleText: "Modo Solo", iconUrl: "star"),
            CategoryRepresentable(percentage: 30, color: .blue, secundaryColor: .systemBlue, currentCenterTitleText: "3000", currentSubTitleText: "Modo Duo", iconUrl: "star"),
            CategoryRepresentable(percentage: 20, color: .red, secundaryColor: .systemRed, currentCenterTitleText: "2000", currentSubTitleText: "Modo Squad", iconUrl: "star"),
            CategoryRepresentable(percentage: 10, color: .green, secundaryColor: .systemGreen, currentCenterTitleText: "1000", currentSubTitleText: "Modo Solo FPP", iconUrl: "star"),
            CategoryRepresentable(percentage: 20, color: .brown, secundaryColor: .systemBrown, currentCenterTitleText: "2000", currentSubTitleText: "Modo Duo FPP", iconUrl: "star"),
            CategoryRepresentable(percentage: 10, color: .yellow, secundaryColor: .systemYellow, currentCenterTitleText: "1000", currentSubTitleText: "Modo Squad FPP", iconUrl: "star")
        ], tooltipLabelTextKey: "Gráfica de las partidas por modos de juego")
    ]
    
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
        bind()
        configUI()
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
                case .getDataGeneral(model: let model):
                    self?.dataGeneralPlayer.build(data: model)
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
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self

        pageControl.numberOfPages = interactiveChart.count
        pageControl.currentPage = 0
        pageControl.backgroundColor = .red
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)

        configScroll()
        configConstraints()
        helpButtonAlert()
        reloadData()
    }
    
    private func configConstraints() {
        contentView.addSubview(levelLabel)
        levelLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(xpLabel)
        xpLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        xpLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        stackView.addArrangedSubview(buttonWeapons)
        stackView.addArrangedSubview(buttonSurvival)
        stackView.addArrangedSubview(buttonModes)
        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: xpLabel.bottomAnchor, constant: 30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        buttonWeapons.widthAnchor.constraint(equalTo: buttonSurvival.widthAnchor).isActive = true
        buttonWeapons.widthAnchor.constraint(equalTo: buttonModes.widthAnchor).isActive = true
        
        dataGeneralPlayer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dataGeneralPlayer)
        dataGeneralPlayer.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30).isActive = true
        dataGeneralPlayer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        dataGeneralPlayer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: dataGeneralPlayer.bottomAnchor, constant: 30).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(interactiveChart.count), height: 360)
        
        for index in 0..<interactiveChart.count {
            let dataGeneralView = ChartView()
            let info = interactiveChart[index]
            dataGeneralView.setCellInfo(info)
            dataGeneralView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(dataGeneralView)
            dataGeneralView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * view.frame.width + 10).isActive = true
            dataGeneralView.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
            dataGeneralView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        }
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageControl)
        pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        contentView.addSubview(radarChartView)
        radarChartView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20).isActive = true
        radarChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        radarChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        radarChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        contentView.addSubview(legendButton)
        legendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        legendButton.bottomAnchor.constraint(equalTo: radarChartView.bottomAnchor).isActive = true
        
        contentView.addSubview(helpButton)
        helpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        helpButton.bottomAnchor.constraint(equalTo: legendButton.topAnchor, constant: -10).isActive = true
        
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
    private func reloadData() {
        if userDefaults.object(forKey: "date") == nil {
            return
        }else {
            let valueDate = userDefaults.object(forKey: "date")
            let date = Date()
            let interval = date.timeIntervalSince(valueDate as! Date)
            if interval < 120 {
                reloadButton.isEnabled = false
                let waitingInterval = 120 - interval
                DispatchQueue.main.asyncAfter(deadline: .now() + waitingInterval) {
                    self.reloadButton.isEnabled = true
                    self.userDefaults.set(nil, forKey: "date")
                }
            } else {
                userDefaults.set(nil, forKey: "date")
            }
        }
    }
    @objc func didTapWeapons() {
        viewModel.goWeapons()
    }
    @objc func didTapSurvival() {
        viewModel.goSurvival()
    }
    @objc func didTapModes() {
        viewModel.goGamesModes()
    }
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let offsetX = view.frame.width * CGFloat(sender.currentPage)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    @objc private func reloadButtonAction() {
        userDefaults.set(Date(), forKey: "date")
         guard userDefaults.bool(forKey: "refreshCount") == true else{
             reloadButton.isEnabled = false
             DispatchQueue.main.asyncAfter(deadline: .now() + 120) {
                 self.reloadButton.isEnabled = true
                 self.userDefaults.set(false, forKey: "refreshCount")
             }
             viewModel.reload()
             return
         }
    }
    @objc private func helpButtonAction() {
        //TODO: cambio idioma
        presentAlert(message: "Puedes cambiar los datos de cada vértice de la gráfica, solo debes pulsar en los datos y elegir el nuevo. Si tienes alguna duda sobre el significado de las siglas pulsa el botón menú que está justo debajo de la gráfica.", title: "Información")
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
    private func helpButtonAlert() {
        guard userDefaults.bool(forKey: "helpButtonBool") == true else{
            helpButtonAction()
            userDefaults.set(true, forKey: "helpButtonBool")
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
