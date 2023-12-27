//
//  ProfilePubgViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {

    private var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private let dependencies: ProfileDependency
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(with: self.view)
        view.setScrollInsect(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        return view
    }()
    
    private lazy var chartView: ChartView = {
        return ChartView()
    }()
    
    init(dependencies: ProfileDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        bind()
        viewModel.viewDidLoad()
    }
}

private extension ProfileViewController {
    func setAppearance() {
        configView()
        addViewToScrollableStackView()
    }
    
    func configView() {
        configureNavigationBar()
        view.backgroundColor = .white
        showSpinner()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .sendGamesMode(let gamesModesData):
                guard let self else { return }
                self.chartView.setCellInfo(PieChartViewData(centerIconKey: "",
                                                            centerTitleText: "Prueba",
                                                            centerSubtitleText: "0",
                                                             categories: [CategoryRepresentable(percentage: 20, color: .red, secundaryColor: .blue, currentCenterTitleText: "balon", currentSubTitleText: "otro", iconUrl: ""),
                                                                          CategoryRepresentable(percentage: 40, color: .green, secundaryColor: .yellow, currentCenterTitleText: "pelota", currentSubTitleText: "otro", iconUrl: "")],
                                                            tooltipLabelTextKey: "prueba de la vista"))
            case .showErrorPlayerDetails:
                self?.presentAlert(message: "Error al cagar los datos de los modos de juego", title: "Error")
            case .hideLoading:
                self?.hideSpinner()
            }
        }.store(in: &cancellable)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "profileViewControllerNavigationItem".localize()
    }
    
    func addViewToScrollableStackView() {
        scrollableStackView.addArrangedSubview(chartView)
    }
}

extension ProfileViewController: MessageDisplayable { }
extension ProfileViewController: SpinnerDisplayable { }
