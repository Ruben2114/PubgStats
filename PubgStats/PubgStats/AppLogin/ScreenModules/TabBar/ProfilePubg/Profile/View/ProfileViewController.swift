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
    private let dependencies: ProfileDependencies
    private var reloadButton = UIBarButtonItem()
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(with: self.view)
        view.setScrollInsect(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        return view
    }()
    private lazy var imageBackground: UIImageView = {
        UIImageView()
    }()
    private lazy var headerView: ProfileHeaderView = {
        return ProfileHeaderView()
    }()
    private lazy var dataGeneralView: ProfileGeneralView = {
        ProfileGeneralView()
    }()
    private lazy var chartView: ChartsInfoView = {
        return ChartsInfoView()
    }()
    private lazy var bottomSheetView: BottomSheetView = {
        BottomSheetView()
    }()
    private lazy var newsCardView: VersatilCardView = {
        VersatilCardView()
    }()
    private lazy var survivalCardView: VersatilCardView = {
        VersatilCardView()
    }()
        
    init(dependencies: ProfileDependencies) {
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
        showLoading() //TODO: cuando entra directamente por aqui no deberia hacer loading
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
        //TODO: cambiar imagen de fondo
        imageBackground.image = UIImage(named: "gamesModesDetailsPubg")
        view.insertSubview(imageBackground, at: 0)
        imageBackground.frame = view.bounds
        configureNavigationBar()
        configureNewsCard()
        configureSurvivalCard()
    }
    
    func bind() {
        bindViewModel()
        bindHeaderView()
        bindChartView()
        bindNewsCardView()
        bindSurvivalCardView()
    }
    
    func bindViewModel() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .showChartView(let infoChartView):
                self?.chartView.isHidden = infoChartView?.count == 0 ? true : false
                self?.chartView.configureViewWith(DefaultChartViewData(charts: infoChartView ?? [], chartSelectedIndex: 0))
            case .showErrorPlayerDetails:
                //TODO: poner en hidden todo lo que tenga datos y que salga la alerta
                //TODO: key
                self?.presentAlert(message: "Error al cargar los datos de los modos de juego", title: "Error")
            case .showHeader(let data):
                self?.headerView.configureView(representable: data)
            case .showDataGeneral(let data):
                self?.dataGeneralView.configureView(data)
            case .hideLoading:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [ weak self] in
                    self?.hideLoading()
                }
            }
        }.store(in: &cancellable)
    }
    
    func bindChartView() {
        chartView.publisher.receive(on: DispatchQueue.main).sink { [weak self] data in
            self?.configureBottomSheet(title: data.0, subtitle: data.1)
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
                }
            }
        }.store(in: &cancellable)
    }
    
    func bindNewsCardView() {
        newsCardView.publisher.sink { [weak self] in
            self?.configureWeb()
        }.store(in: &cancellable)
    }
    
    func bindSurvivalCardView() {
        survivalCardView.publisher.sink { [weak self] in
            self?.viewModel.goToSurvival()
        }.store(in: &cancellable)
    }
    
    func configureNavigationBar() {
        titleNavigation("profileViewControllerNavigationItem")
        //TODO: meter el reload como una propiedad del scroll de la tabla y meterle un loading de carga
        let helpReloadButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpReloadButtonAction))
        helpReloadButton.tintColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise.circle.fill"), style: .plain, target: self, action: #selector(reloadButtonAction))
        reloadButton.tintColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        navigationItem.setRightBarButtonItems([reloadButton, helpReloadButton], animated: true)
    }
    
    func addViewToScrollableStackView() {
        scrollableStackView.addArrangedSubview(headerView)
        scrollableStackView.addArrangedSubview(dataGeneralView)
        scrollableStackView.addArrangedSubview(chartView)
        scrollableStackView.addArrangedSubview(survivalCardView)
        scrollableStackView.addArrangedSubview(newsCardView)
    }
    
    func configureBottomSheet(title: String, subtitle: String) {
        bottomSheetView.show(in: self, title: title, subtitle: subtitle)
    }
    
    func configureNewsCard() {
        //TODO: poner localized
        let model = DefaultVersatilCard(title: "Noticias",
                                        subTitle: "Aqui podras ver las noticias de las ultimas novedades del juego",
                                        customImageView: "star")
        newsCardView.setupVersatilCard(model)
    }
    
    func configureSurvivalCard() {
        //TODO: poner localized
        let model = DefaultVersatilCard(title: "profileCardSurvival".localize(),
                                        subTitle: "Aqui podras ver tus estadísticas en el modo supervivencia",
                                        customImageView: "survivalSerie")
        survivalCardView.setupVersatilCard(model)
    }
    
    func configureWeb() {
        guard let url = URL(string: "https://pubg.com/es/news") else { return }
        let safariService = SFSafariViewController(url: url)
        safariService.dismissButtonStyle = .close
        present(safariService, animated: true)
    }
    
    @objc private func helpReloadButtonAction() {
        //TODO: poner localized
        configureBottomSheet(title: "Información sobre la recarga",
                             subtitle: "Si necesitas recargar la vista puedes pulsar el botón de recarga que esta justo a la derecha del punto de información que acabas de pulsar. una vez pulsada la recarga volverá a estar activa a los dos minutos.")
    }
    
    @objc private func reloadButtonAction() {
        UserDefaults.standard.set(Date(), forKey: "date")
        reloadButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) { [weak self] in
            self?.reloadButton.isEnabled = true
        }
        showLoading()
        viewModel.reload()
    }
}

extension ProfileViewController: MessageDisplayable { }
extension ProfileViewController: LoadingPresentationDisplayable { }
