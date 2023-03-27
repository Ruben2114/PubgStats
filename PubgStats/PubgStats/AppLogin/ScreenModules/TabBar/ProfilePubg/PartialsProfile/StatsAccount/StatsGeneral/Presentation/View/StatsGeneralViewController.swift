//
//  StatsGeneralViewController.swift
//  AppPubgStats
//
//  Created by Ruben Rodriguez on 20/2/23.
//

import UIKit
import Combine
import CoreData


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
    
    init(dependencies: StatsGeneralDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bind()
    }
    private func configUI() {
        title = "Tus Estadisticas generales"
        backButton(action: #selector(backButtonAction))
    }
    
    private func bind() {
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        nameLabel?.text = sessionUser.player
        //TODO: GUARDAR toda la info en sessionUser y luego utilizarla para no hacer mas llamadas a no ser que recarguemos
        
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
                    self?.hideSpinner()
                    self?.viewModel.saveGamesModeData(gamesModeData: [model.self])
                }
            }.store(in: &cancellable)
        guard let id = sessionUser.account, !id.isEmpty else {return}
        viewModel.fetchDataGeneral(account: id)
    }
    @objc func backButtonAction() {
        viewModel.backButton()
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
    //goKillsData, goWeapons, goSurvival, goGamesModes
}
extension StatsGeneralViewController: SpinnerDisplayable { }


