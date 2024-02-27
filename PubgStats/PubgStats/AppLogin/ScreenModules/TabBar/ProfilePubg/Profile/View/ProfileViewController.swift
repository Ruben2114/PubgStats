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
    private lazy var headerView: ProfileHeaderView = {
        return ProfileHeaderView()
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
    //TODO: hacer esta vista general ya que hay que poner la de news y la de survival
    private lazy var newsCardView: NewsCardView = {
        NewsCardView()
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
        showLoading()
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
        view.backgroundColor = .white
        configureNavigationBar()
        configureNewsCard()
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
                //TODO: key
                self?.presentAlert(message: "Error al cargar los datos de los modos de juego", title: "Error")
            case .hideLoading:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [ weak self] in
                    self?.hideLoading()
                }
            case .showHeader(let data):
                self?.headerView.configureView(representable: data)
            }
        }.store(in: &cancellable)
    }
    
    func bindChartView() {
        //TODO: poner localized
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
            }
        }.store(in: &cancellable)
    }
    
    func bindNewsCardView() {
        newsCardView.publisher.sink { [weak self] in
            self?.configureWeb()
        }.store(in: &cancellable)
    }
    
    func configureNavigationBar() {
        titleNavigation("profileViewControllerNavigationItem")
        let helpReloadButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpReloadButtonAction))
        reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise.circle.fill"), style: .plain, target: self, action: #selector(reloadButtonAction))
        navigationItem.setRightBarButtonItems([reloadButton, helpReloadButton], animated: true)
    }
    
    func addViewToScrollableStackView() {
        scrollableStackView.addArrangedSubview(headerView)
        scrollableStackView.addArrangedSubview(dataGeneralView)
        scrollableStackView.addArrangedSubview(chartView)
        scrollableStackView.addArrangedSubview(newsCardView)
    }
    
    func configureBottomSheet(title: String, subtitle: String) {
        bottomSheetView.show(in: self, title: title, subtitle: subtitle)
    }
    
    func configureNewsCard() {
        //TODO: poner localized
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
        //TODO: poner localized
        configureBottomSheet(title: "Información sobre la recarga",
                             subtitle: "Si necesitas recargar la vista puedes pulsar el botón de recarga que esta justo a la derecha del punto de información que acabas de pulsar. una vez pulsda la recarga volverá a estar activa a los dos minutos.")
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
extension ProfileViewController: LoadingPresentationDisplayable { }
