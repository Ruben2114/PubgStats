//
//  StatsGeneralViewController.swift
//  AppPubgStats
//
//  Created by Ruben Rodriguez on 20/2/23.
//

import UIKit
import Combine

class StatsGeneralViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    @IBOutlet weak var XPLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var top10sLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var bestRankedPosition: UILabel!
    private var cancellable = Set<AnyCancellable>()
    private let dependencies: StatsGeneralDependency
    private let viewModel: StatsGeneralViewModel
    var mainScrollView = UIScrollView()
    var refreshControl = UIRefreshControl()
    let sessionUser: ProfileEntity
    
    init(mainScrollView: UIScrollView = UIScrollView(), dependencies: StatsGeneralDependency) {
        self.mainScrollView = mainScrollView
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
        configScroll(selector: #selector(refreshData))
        configUI()
        bind()
    }
    private func configUI() {
        title = "Tus Estadisticas generales"
        backButton(action: #selector(backButtonAction))
    }
    
    private func bind() {
        nameLabel?.text = sessionUser.player
        if sessionUser.survival != nil, sessionUser.gameModes != nil {
            guard let dataSurvival = sessionUser.survival?.first?.data.attributes else {return}
            XPLabel?.text = "\(dataSurvival.xp)\nXP"
            levelLabel?.text = "Nivel\n\(dataSurvival.level)"
            guard let dataGamesMode = sessionUser.gameModes?.first else {return}
            killsLabel?.text = "\(dataGamesMode.killsTotal)\nMuertes"
            top10sLabel?.text = "\(dataGamesMode.top10STotal)\nTop10S"
            gamesPlayedLabel?.text = "\(dataGamesMode.gamesPlayed)\nPartidas"
            winsLabel?.text = "\(dataGamesMode.wonTotal)\nVictorias"
            timePlayedLabel?.text = "\(dataGamesMode.timePlayed)\nTiempo Jugado"
            bestRankedPosition?.text = "\(dataGamesMode.bestRank)\nMejor ranked"
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
                        self?.XPLabel?.text = "\(model.data.attributes.xp)\nXP"
                        self?.levelLabel?.text = "Nivel\n\(model.data.attributes.level)"
                        self?.viewModel.saveSurvivalData(survivalData: [model.self])
                    case .successGamesModes(model: let model):
                        self?.killsLabel?.text = "\(model.killsTotal)\nMuertes"
                        self?.top10sLabel?.text = "\(model.top10STotal)\nTop10S"
                        self?.gamesPlayedLabel?.text = "\(model.gamesPlayed)\nPartidas"
                        self?.winsLabel?.text = "\(model.wonTotal)\nVictorias"
                        self?.timePlayedLabel?.text = "\(model.timePlayed)\nTiempo Jugado"
                        self?.bestRankedPosition?.text = "\(model.bestRank)\nMejor ranked"
                        self?.viewModel.saveGamesModeData(gamesModeData: [model.self])
                    case .success:
                        self?.hideSpinner()
                    }
                }.store(in: &cancellable)
            guard let id = sessionUser.account, !id.isEmpty else {return}
            viewModel.fetchDataGeneral(account: id)
        }
    }
    @objc func backButtonAction() {
        viewModel.backButton()
    }
    
    var refreshCount = 0
    var isFirstRechargeDone = false
    
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
    
    @IBAction func goKillsData(_ sender: UIButton) {
        viewModel.goKillsData()
    }
    @IBAction func goWeapons(_ sender: UIButton) {
        viewModel.goWeapons()
    }
    @IBAction func goSurvival(_ sender: UIButton) {
        viewModel.goSurvival()
    }
    @IBAction func goGamesModes(_ sender: UIButton) {
        viewModel.goGamesModes()
    }
}
extension StatsGeneralViewController: SpinnerDisplayable { }
extension StatsGeneralViewController: ViewScrollableXib {}
extension StatsGeneralViewController: MessageDisplayable{ }

