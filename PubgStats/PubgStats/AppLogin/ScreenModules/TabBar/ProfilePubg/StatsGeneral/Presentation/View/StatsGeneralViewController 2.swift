//
//  StatsGeneralViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

import UIKit
import Combine

final class StatsGeneralViewController: UIViewController {
    private lazy var levelLabel = makeLabel(height: 78)
    private lazy var nameLabel = makeLabel(height: 21)
    private lazy var xpLabel = makeLabel(height: 21)
    private lazy var stackStackView = makeStack(space: 5)
    private lazy var labelFirstStackView = makeStackHorizontal(space: 5)
    private lazy var winsLabel = makeLabel(height: 65)
    private lazy var killsLabel = makeLabel(height: 65)
    private lazy var top10sLabel = makeLabel(height: 65)
    private lazy var labelSecondStackView = makeStackHorizontal(space: 5)
    private lazy var gamesPlayedLabel = makeLabel(height: 65)
    private lazy var timePlayedLabel = makeLabel(height: 65)
    private lazy var bestRankedLabel = makeLabel(height: 65)
    private lazy var buttonStackView = makeStack(space: 27)
    private lazy var goKillsData = makeButtonBlue(title: "Datos Muertes")
    private lazy var goWeapons = makeButtonBlue(title: "Datos Armas")
    private lazy var goSurvival = makeButtonBlue(title: "Estadisticas Survival")
    private lazy var goGamesModes = makeButtonBlue(title: "Modos de juego")
    
    private var cancellable = Set<AnyCancellable>()
    private let dependencies: StatsGeneralDependency
    private let viewModel: StatsGeneralViewModel
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var refreshControl = UIRefreshControl()
    let sessionUser: ProfileEntity
    var refreshCount = 0
    var isFirstRechargeDone = false
    
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), dependencies: StatsGeneralDependency) {
        self.mainScrollView = mainScrollView
        self.contentView = contentView
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
        configScroll()
        configUI()
        configConstraints()
        configTargets()
        bind()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Tus Estadisticas generales"
        backButton(action: #selector(backButtonAction))
        stackStackView.backgroundColor = .systemCyan
        mainScrollView.refreshControl = UIRefreshControl()
        mainScrollView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    private func bind() {
        nameLabel.text = sessionUser.player
        if sessionUser.survival != nil, sessionUser.gameModes != nil {
            guard let dataSurvival = sessionUser.survival?.first?.data.attributes else {return}
            xpLabel.text = "\(dataSurvival.xp)\nXP"
            levelLabel.text = "Nivel\n\(dataSurvival.level)"
            guard let dataGamesMode = sessionUser.gameModes?.first else {return}
            killsLabel.text = "\(dataGamesMode.killsTotal)\nMuertes"
            top10sLabel.text = "\(dataGamesMode.top10STotal)\nTop10S"
            gamesPlayedLabel.text = "\(dataGamesMode.gamesPlayed)\nPartidas"
            winsLabel.text = "\(dataGamesMode.wonTotal)\nVictorias"
            timePlayedLabel.text = "\(dataGamesMode.timePlayed)\nTiempo Jugado"
            bestRankedLabel.text = "\(dataGamesMode.bestRank)\nMejor ranked"
        }else{
            viewModel.state.receive(on: DispatchQueue.main)
                .sink { [weak self ] state in
                    switch state {
                    case .loading:
                        self?.showSpinner()
                    case .fail(error: let error):
                        //TODO: manejar errores
                        print(error)
                    case .successSurvival(model: let model):
                        self?.xpLabel.text = "\(model.data.attributes.xp) XP"
                        self?.levelLabel.text = "Nivel\n\(model.data.attributes.level)"
                        self?.viewModel.saveSurvivalData(survivalData: [model.self])
                    case .successGamesModes(model: let model):
                        self?.killsLabel.text = "\(model.killsTotal)\nMuertes"
                        self?.top10sLabel.text = "\(model.top10STotal)\nTop10S"
                        self?.gamesPlayedLabel.text = "\(model.gamesPlayed)\nPartidas"
                        self?.winsLabel.text = "\(model.wonTotal)\nVictorias"
                        self?.timePlayedLabel.text = "\(model.timePlayed)\nTiempo Jugado"
                        self?.bestRankedLabel.text = "\(model.bestRank)\nMejor ranked"
                        self?.viewModel.saveGamesModeData(gamesModeData: [model.self])
                    case .success:
                        self?.hideSpinner()
                    }
                }.store(in: &cancellable)
            guard let id = sessionUser.account, !id.isEmpty else {return}
            viewModel.fetchDataGeneral(account: id)
        }
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
        
        [winsLabel,killsLabel, top10sLabel].forEach {
            labelFirstStackView.addArrangedSubview($0)
        }
        
        [gamesPlayedLabel,timePlayedLabel,bestRankedLabel].forEach {
            labelSecondStackView.addArrangedSubview($0)
        }
        contentView.addSubview(buttonStackView)
        buttonStackView.topAnchor.constraint(equalTo: stackStackView.bottomAnchor, constant: 61).isActive = true
        buttonStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
        [goKillsData, goWeapons, goSurvival, goGamesModes].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    private func configTargets() {
        goKillsData.addTarget(self, action: #selector(didTapGoKillsData), for: .touchUpInside)
        goWeapons.addTarget(self, action: #selector(didTapGoWeapons), for: .touchUpInside)
        goSurvival.addTarget(self, action: #selector(didTapGoSurvival), for: .touchUpInside)
        goGamesModes.addTarget(self, action: #selector(didTapGoGamesModes), for: .touchUpInside)
    }
    @objc func didTapGoKillsData() {
        viewModel.goKillsData()
    }
    @objc func didTapGoWeapons() {
        viewModel.goWeapons()
    }
    @objc func didTapGoSurvival() {
        viewModel.goSurvival()
    }
    @objc func didTapGoGamesModes() {
        viewModel.goGamesModes()
    }
    
    @objc func backButtonAction() {
        viewModel.backButton()
    }
    @objc func refreshData() {
        guard refreshCount < 2 else {
            mainScrollView.refreshControl?.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                print("ahora si")
                self.refreshCount = 0
            }
            return}
        refreshCount += 1
        sessionUser.survival = nil
        sessionUser.gameModes = nil
        bind()
        mainScrollView.refreshControl?.endRefreshing()
        mainScrollView.refreshControl?.endRefreshing()
        
    }
    private func makeLabel(height: CGFloat) -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.setHeightConstraint(with: height)
        return label
    }
}
extension StatsGeneralViewController: MessageDisplayable { }
extension StatsGeneralViewController: ViewScrollable {}
extension StatsGeneralViewController: SpinnerDisplayable { }

