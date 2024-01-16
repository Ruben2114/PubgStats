//
//  ProfilePubgViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Combine
import SafariServices

final class ProfileViewController: UIViewController {

    private var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private let dependencies: ProfileDependency
    private var reloadButton = UIBarButtonItem()
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(with: self.view)
        view.setScrollInsect(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        return view
    }()
    
    private lazy var headerView: ProfileHeaderView = {
        return ProfileHeaderView()
    }()
    
    private lazy var graphView: GraphInfoModesView = {
        return GraphInfoModesView()
    }()
    
    private lazy var dataGeneralView: DataGeneralView = {
        DataGeneralView()
    }()
    
    private lazy var chartView: ChartsInfoView = {
        return ChartsInfoView()
    }()
    
    private lazy var bottomSheetView: BottomSheetView = {
        BottomSheetView()
    }()
    
    private lazy var newsCardView: NewsCardView = {
        NewsCardView()
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
        configureNewsCard()
        view.backgroundColor = .white
        showSpinner()
    }
    
    func bind() {
        bindViewModel()
        bindHeaderView()
        bindChartView()
        bindNewsCardView()
    }
    
    func bindViewModel() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .showChartView(let infoChartView):
                guard let self else { return }
                self.chartView.isHidden = infoChartView?.count == 0 ? true : false
                self.chartView.configureViewWith(DefaultChartViewData(charts: infoChartView ?? [], chartSelectedIndex: 0))
            case .showErrorPlayerDetails:
                //TODO: poner en hidden todo lo que tenga datos y que salga la alerta
                self?.presentAlert(message: "Error al cagar los datos de los modos de juego", title: "Error")
            case .hideLoading:
                self?.hideSpinner()
            case .showGraphView(let data):
                self?.graphView.configureWith(representable: data)
            }
        }.store(in: &cancellable)
    }
    
    func bindChartView() {
        chartView.publisher.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .didTapAverageTooltip:
                self?.configureBottomSheet(title: "Kills data", subtitle: "aqui podras observar las muertes totales y las muertes de noseque nose cuantas")
            case .didTapHelpTooltip:
                self?.configureBottomSheet(title: "datos por categorias", subtitle: "las tres secciones que podras ver aqui los kills, noseque")
            }
        }.store(in: &cancellable)
    }
    
    func  bindHeaderView() {
        headerView.publisher.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .didSelectButton(let type):
                switch type {
                case .modes:
                    self?.viewModel.goToModes()
                case .weapon:
                    self?.viewModel.goToWeapon()
                case .survival:
                    self?.viewModel.goToSurvival()
                }
            case .didTapHelpTooltip:
                break
                //TODO: presentar el bottomSheet
            }
        }.store(in: &cancellable)
    }
    
    func bindNewsCardView() {
        newsCardView.publisher.sink { [weak self] in
            self?.configureWeb()
        }.store(in: &cancellable)
    }
    
    func configureNavigationBar() {
        //TODO: poner arriba y ala izquierda un texto : PUBGSTATS
        navigationItem.title = "profileViewControllerNavigationItem".localize()
        let helpReloadButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpReloadButtonAction))
        reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise.circle.fill"), style: .plain, target: self, action: #selector(reloadButtonAction))
        self.navigationItem.setRightBarButtonItems([reloadButton, helpReloadButton], animated: true)
    }
    
    func addViewToScrollableStackView() {
        //TODO: dentro del header meter una vista con el name, level, xp, una foto de la platform ... datos mas generales
        scrollableStackView.addArrangedSubview(headerView)
        scrollableStackView.addArrangedSubview(graphView)
        scrollableStackView.addArrangedSubview(dataGeneralView)
        scrollableStackView.addArrangedSubview(chartView)
        scrollableStackView.addArrangedSubview(newsCardView)
    }
    
    func configureBottomSheet(title: String, subtitle: String) {
        bottomSheetView.show(in: self, title: title, subtitle: subtitle)
    }
    
    func configureNewsCard() {
        let model = DefaultNewsCard(title: "Noticias",
                                    subTitle: "Aqui podras ver las noticias de las ultimas novedades del juego",
                                    customImageView: "star")
        newsCardView.setupVersatilCard(model)
    }
    
    func configureWeb() {
        guard let url = URL(string: "https://pubg.com/es/news") else { return }
        let safariService = SFSafariViewController(url: url)
        safariService.dismissButtonStyle = .close
        present(safariService, animated: true)
    }
    
    @objc private func helpReloadButtonAction() {
        print("mostrar info del reload en un botomsheet")
    }
    
    @objc private func reloadButtonAction() {
        UserDefaults.standard.set(Date(), forKey: "date")
         guard UserDefaults.standard.bool(forKey: "refreshCount") == true else {
             reloadButton.isEnabled = false
             DispatchQueue.main.asyncAfter(deadline: .now() + 120) { [weak self] in
                 self?.reloadButton.isEnabled = true
                 UserDefaults.standard.set(false, forKey: "refreshCount")
             }
             viewModel.reload()
             return
         }
    }
}

extension ProfileViewController: MessageDisplayable { }
extension ProfileViewController: SpinnerDisplayable { }
