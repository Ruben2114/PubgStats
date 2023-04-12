//
//  StatsGeneralViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

import UIKit
import Combine

final class StatsGeneralViewController: UIViewController {
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
    private lazy var buttonStackView = makeStack(space: 27)
    private lazy var goKillsData = makeButtonBlue(title: "Datos Muertes")
    private lazy var goWeapons = makeButtonBlue(title: "Datos Armas")
    private lazy var goSurvival = makeButtonBlue(title: "Estadisticas Survival")
    private lazy var goGamesModes = makeButtonBlue(title: "Modos de juego")
    
    private var cancellable = Set<AnyCancellable>()
    private let dependencies: StatsGeneralDependency
    private let viewModel: StatsGeneralViewModel
    let sessionUser: ProfileEntity
    var refreshCount = 0
    var isFirstRechargeDone = false
    
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
        configTargets()
        bind()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Tus Estadisticas generales"
        backButton(action: #selector(backButtonAction))
        stackStackView.backgroundColor = .systemCyan
    }
    private func bind() {
        nameLabel.text = sessionUser.player
        let survivalData = viewModel.getSurvival(for: sessionUser)
        let gamesModesData = viewModel.getGamesModes(for: sessionUser)
        if survivalData?.survival != nil, gamesModesData?.first?.gamesMode != nil{
            xpLabel.text = survivalData?.xp
            levelLabel.text = survivalData?.level
            killsLabel.text = "\(gamesModesData?[0].killsTotal ?? 0)\nMuertes"
            top10sLabel.text = "\(gamesModesData?[0].top10STotal ?? 0)\nTop10S"
            gamesPlayedLabel.text = "\(gamesModesData?[0].gamesPlayed ?? 0)\nPartidas"
            winsLabel.text = "\(gamesModesData?[0].wonTotal ?? 0)\nVictorias"
            timePlayedLabel.text = "\(gamesModesData?[0].timePlayed ?? "0")\nTiempo Jugado"
            bestRankedLabel.text = "\(gamesModesData?[0].bestRankPoint ?? 0)\nMejor ranked"
        }else{
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
                        guard let user = self?.sessionUser else{return}
                        self?.viewModel.saveSurvival(sessionUser: user, survivalData: [model.self])
                    case .successGamesModes(model: let model):
                        self?.killsLabel.text = "\(model.killsTotal)\nMuertes"
                        self?.top10sLabel.text = "\(model.top10STotal)\nTop10S"
                        self?.gamesPlayedLabel.text = "\(model.gamesPlayed)\nPartidas"
                        self?.winsLabel.text = "\(model.wonTotal)\nVictorias"
                        self?.timePlayedLabel.text = "\(model.timePlayed)\nTiempo Jugado"
                        self?.bestRankedLabel.text = "\(model.bestRank)\nMejor ranked"
                        guard let user = self?.sessionUser else{return}
                        self?.viewModel.saveGamesModeData(sessionUser: user, gamesModeData: [model.self])
                    case .success:
                        self?.hideSpinner()
                    }
                }.store(in: &cancellable)
            guard let id = sessionUser.account, !id.isEmpty else {return}
            viewModel.fetchDataGeneral(account: id)
        }
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
        view.addSubview(buttonStackView)
        buttonStackView.topAnchor.constraint(equalTo: stackStackView.bottomAnchor, constant: 61).isActive = true
        buttonStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
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
}
extension StatsGeneralViewController: MessageDisplayable { }
extension StatsGeneralViewController: SpinnerDisplayable { }

